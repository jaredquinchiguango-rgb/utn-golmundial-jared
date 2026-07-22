package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.FaseDTO;
import ec.edu.utn.golmundial.dto.estadisticas.GrupoDTO;
import ec.edu.utn.golmundial.dto.estadisticas.PartidoDTO;
import ec.edu.utn.golmundial.dto.estadisticas.SedeDTO;
import ec.edu.utn.golmundial.dto.estadisticas.SeleccionDTO;
import ec.edu.utn.golmundial.service.estadisticas.FaseService;
import ec.edu.utn.golmundial.service.estadisticas.GrupoService;
import ec.edu.utn.golmundial.service.estadisticas.PartidoService;
import ec.edu.utn.golmundial.service.estadisticas.SedeService;
import ec.edu.utn.golmundial.service.estadisticas.SeleccionService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

/**
 * IMPORTANTE sobre @ViewScoped: al redirigir de una vista (ej. lista.xhtml)
 * a otra distinta (ej. formulario.xhtml o resultado.xhtml), JSF crea una
 * instancia NUEVA de este bean para la vista destino - el estado de la
 * vista anterior (partidoSeleccionado, etc.) NO viaja solo. Por eso el id
 * del registro se manda por la URL (f:viewParam) y cada vista lo vuelve a
 * buscar en preRenderView, en vez de depender de un campo ya seteado.
 */
@Named
@ViewScoped
public class PartidoBean implements Serializable {

    @Inject private PartidoService   partidoService;
    @Inject private SeleccionService seleccionService;
    @Inject private SedeService      sedeService;
    @Inject private FaseService      faseService;
    @Inject private GrupoService     grupoService;
    @Inject private LoginBean        loginBean;

    private List<PartidoDTO>   partidos;
    private List<SeleccionDTO> selecciones;
    private List<SedeDTO>      sedes;
    private List<FaseDTO>      fases;
    private List<GrupoDTO>     grupos;

    // Bindeado por <f:viewParam name="id"> en formulario.xhtml y resultado.xhtml
    private Integer idPartidoParam;

    private PartidoDTO partidoSeleccionado;
    private Integer    golesLocalForm;
    private Integer    golesVisitanteForm;

    private Integer    idPartidoEnEdicion;
    private Integer    numeroPartidoFifaForm;
    private String     fechaForm;
    private String     horaForm;
    private String      statusForm;
    private Integer    idFaseForm;
    private Integer    idSedeForm;
    private Integer    idGrupoForm;
    private Integer    idSeleccionLocalForm;
    private Integer    idSeleccionVisitanteForm;
    private BigDecimal homeOddsForm;
    private BigDecimal drawOddsForm;
    private BigDecimal awayOddsForm;

    @PostConstruct
    public void init() {
        cargarPartidos();
        selecciones = seleccionService.listarTodas();
        sedes = sedeService.listarTodas();
        fases = faseService.listarTodas();
        grupos = grupoService.listarTodos();
    }

    public void cargarPartidos() {
        partidos = partidoService.listarTodos();
    }

    // ---------------------------------------------------------------
    // Navegacion (solo arman la URL con el id, ya no setean estado)
    // ---------------------------------------------------------------

    public String prepararNuevo() {
        return "/partidos/formulario?faces-redirect=true";
    }

    public String prepararEditar(PartidoDTO partido) {
        return "/partidos/formulario?faces-redirect=true&id=" + partido.getIdPartido();
    }

    public String prepararResultado(PartidoDTO partido) {
        return "/partidos/resultado?faces-redirect=true&id=" + partido.getIdPartido();
    }

    // ---------------------------------------------------------------
    // preRenderView de partidos/formulario.xhtml - busca el partido por
    // idPartidoParam DENTRO de la lista ya cargada en este init() (no
    // depende de ningun estado de la vista anterior)
    // ---------------------------------------------------------------

    public void inicializarFormulario() {
        if (FacesContext.getCurrentInstance().isPostback()) {
            return; // no reinicializar si es un postback (ej. fallo de validacion)
        }

        if (idPartidoParam == null) {
            // Modo "nuevo"
            idPartidoEnEdicion = null;
            numeroPartidoFifaForm = null;
            fechaForm = null;
            horaForm = null;
            statusForm = "PROGRAMADO";
            idFaseForm = null;
            idSedeForm = null;
            idGrupoForm = null;
            idSeleccionLocalForm = null;
            idSeleccionVisitanteForm = null;
            homeOddsForm = null;
            drawOddsForm = null;
            awayOddsForm = null;
            return;
        }

        // Modo "editar"
        PartidoDTO partido = partidos.stream()
                .filter(p -> idPartidoParam.equals(p.getIdPartido()))
                .findFirst().orElse(null);

        if (partido == null) {
            msg(FacesMessage.SEVERITY_ERROR, "No se encontro el partido solicitado.");
            return;
        }

        idPartidoEnEdicion = partido.getIdPartido();
        numeroPartidoFifaForm = partido.getNumeroPartidoFifa();

        if (partido.getFechaHoraUtc() != null) {
            fechaForm = partido.getFechaHoraUtc().toLocalDate().toString();
            horaForm = String.format("%02d:%02d",
                    partido.getFechaHoraUtc().getHour(), partido.getFechaHoraUtc().getMinute());
        } else {
            fechaForm = null;
            horaForm = null;
        }

        statusForm = partido.getEstado();
        idSeleccionLocalForm = resolverIdSeleccionPorNombre(partido.getNombreSeleccionLocal());
        idSeleccionVisitanteForm = resolverIdSeleccionPorNombre(partido.getNombreSeleccionVisitante());
        idSedeForm = resolverIdSedePorNombre(partido.getNombreSede());
        idFaseForm = resolverIdFasePorNombre(partido.getNombreFase());
        idGrupoForm = resolverIdGrupoPorNombre(partido.getNombreGrupo());
        homeOddsForm = null;
        drawOddsForm = null;
        awayOddsForm = null;
    }

    // ---------------------------------------------------------------
    // preRenderView de partidos/resultado.xhtml
    // ---------------------------------------------------------------

    public void inicializarResultado() {
        if (FacesContext.getCurrentInstance().isPostback()) {
            return;
        }
        if (idPartidoParam == null) {
            msg(FacesMessage.SEVERITY_ERROR, "No se especifico el partido.");
            return;
        }
        partidoSeleccionado = partidos.stream()
                .filter(p -> idPartidoParam.equals(p.getIdPartido()))
                .findFirst().orElse(null);

        if (partidoSeleccionado == null) {
            msg(FacesMessage.SEVERITY_ERROR, "No se encontro el partido solicitado.");
            return;
        }
        golesLocalForm = partidoSeleccionado.getGolesLocal();
        golesVisitanteForm = partidoSeleccionado.getGolesVisitante();
    }

    private Integer resolverIdSeleccionPorNombre(String nombre) {
        if (nombre == null || selecciones == null) return null;
        return selecciones.stream()
                .filter(s -> nombre.equals(s.getNombre()))
                .map(SeleccionDTO::getIdSeleccion)
                .findFirst().orElse(null);
    }

    private Integer resolverIdSedePorNombre(String nombreSede) {
        if (nombreSede == null || sedes == null) return null;
        return sedes.stream()
                .filter(s -> nombreSede.equals(s.getEstadio()))
                .map(SedeDTO::getIdSede)
                .findFirst().orElse(null);
    }

    private Integer resolverIdFasePorNombre(String nombreFase) {
        if (nombreFase == null || fases == null) return null;
        return fases.stream()
                .filter(f -> nombreFase.equals(f.getNombre()))
                .map(FaseDTO::getIdFase)
                .findFirst().orElse(null);
    }

    private Integer resolverIdGrupoPorNombre(String nombreGrupo) {
        if (nombreGrupo == null || grupos == null) return null;
        return grupos.stream()
                .filter(g -> nombreGrupo.equals(g.getNombre()))
                .map(GrupoDTO::getIdGrupo)
                .findFirst().orElse(null);
    }

    public String guardar() {
        LocalDateTime fechaHoraUtc = combinarFechaHora();
        boolean exito;

        if (idPartidoEnEdicion == null) {
            exito = partidoService.crear(numeroPartidoFifaForm, fechaHoraUtc, statusForm,
                    idFaseForm, idSedeForm, idGrupoForm,
                    idSeleccionLocalForm, idSeleccionVisitanteForm,
                    homeOddsForm, drawOddsForm, awayOddsForm,
                    loginBean.getCorreo(), loginBean.getClave());
        } else {
            exito = partidoService.actualizar(idPartidoEnEdicion, numeroPartidoFifaForm, fechaHoraUtc, statusForm,
                    idFaseForm, idSedeForm, idGrupoForm,
                    idSeleccionLocalForm, idSeleccionVisitanteForm,
                    homeOddsForm, drawOddsForm, awayOddsForm,
                    loginBean.getCorreo(), loginBean.getClave());
        }

        if (exito) {
            cargarPartidos();
            msg(FacesMessage.SEVERITY_INFO, idPartidoEnEdicion == null
                    ? "Partido creado correctamente." : "Partido actualizado correctamente.");
            return "/partidos/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo guardar el partido. Verifique los datos.");
        return null;
    }

    private LocalDateTime combinarFechaHora() {
        if (fechaForm == null || fechaForm.isBlank()) return null;
        LocalDate fecha = LocalDate.parse(fechaForm);
        LocalTime hora = (horaForm != null && !horaForm.isBlank()) ? LocalTime.parse(horaForm) : LocalTime.MIDNIGHT;
        return LocalDateTime.of(fecha, hora);
    }

    public String guardarResultado() {
        if (partidoSeleccionado == null) {
            msg(FacesMessage.SEVERITY_ERROR, "No hay partido seleccionado.");
            return null;
        }
        boolean exito = partidoService.registrarResultado(
                partidoSeleccionado.getIdPartido(), golesLocalForm, golesVisitanteForm,
                loginBean.getCorreo(), loginBean.getClave());
        if (exito) {
            cargarPartidos();
            msg(FacesMessage.SEVERITY_INFO,
                "Resultado registrado. Las predicciones se liquidan automaticamente.");
            return "/partidos/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo registrar el resultado.");
        return null;
    }

    public String cancelar() {
        return "/partidos/lista?faces-redirect=true";
    }

    private void msg(FacesMessage.Severity nivel, String texto) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(nivel, texto, null));
    }

    public boolean isEsEdicion() { return idPartidoEnEdicion != null; }

    public List<PartidoDTO>   getPartidos()     { return partidos; }
    public List<SeleccionDTO> getSelecciones()  { return selecciones; }
    public List<SedeDTO>      getSedes()        { return sedes; }
    public List<FaseDTO>      getFases()        { return fases; }
    public List<GrupoDTO>     getGrupos()       { return grupos; }

    public Integer getIdPartidoParam()          { return idPartidoParam; }
    public void    setIdPartidoParam(Integer v) { this.idPartidoParam = v; }

    public PartidoDTO getPartidoSeleccionado()              { return partidoSeleccionado; }
    public void       setPartidoSeleccionado(PartidoDTO v)  { this.partidoSeleccionado = v; }

    public Integer getGolesLocalForm()                      { return golesLocalForm; }
    public void    setGolesLocalForm(Integer v)             { this.golesLocalForm = v; }

    public Integer getGolesVisitanteForm()                   { return golesVisitanteForm; }
    public void    setGolesVisitanteForm(Integer v)          { this.golesVisitanteForm = v; }

    public Integer getNumeroPartidoFifaForm()                { return numeroPartidoFifaForm; }
    public void    setNumeroPartidoFifaForm(Integer v)       { this.numeroPartidoFifaForm = v; }

    public String  getFechaForm()                            { return fechaForm; }
    public void    setFechaForm(String v)                    { this.fechaForm = v; }

    public String  getHoraForm()                             { return horaForm; }
    public void    setHoraForm(String v)                     { this.horaForm = v; }

    public String  getStatusForm()                           { return statusForm; }
    public void    setStatusForm(String v)                   { this.statusForm = v; }

    public Integer getIdFaseForm()                           { return idFaseForm; }
    public void    setIdFaseForm(Integer v)                  { this.idFaseForm = v; }

    public Integer getIdSedeForm()                           { return idSedeForm; }
    public void    setIdSedeForm(Integer v)                  { this.idSedeForm = v; }

    public Integer getIdGrupoForm()                          { return idGrupoForm; }
    public void    setIdGrupoForm(Integer v)                 { this.idGrupoForm = v; }

    public Integer getIdSeleccionLocalForm()                 { return idSeleccionLocalForm; }
    public void    setIdSeleccionLocalForm(Integer v)        { this.idSeleccionLocalForm = v; }

    public Integer getIdSeleccionVisitanteForm()             { return idSeleccionVisitanteForm; }
    public void    setIdSeleccionVisitanteForm(Integer v)    { this.idSeleccionVisitanteForm = v; }

    public BigDecimal getHomeOddsForm()                      { return homeOddsForm; }
    public void       setHomeOddsForm(BigDecimal v)          { this.homeOddsForm = v; }

    public BigDecimal getDrawOddsForm()                      { return drawOddsForm; }
    public void       setDrawOddsForm(BigDecimal v)          { this.drawOddsForm = v; }

    public BigDecimal getAwayOddsForm()                      { return awayOddsForm; }
    public void       setAwayOddsForm(BigDecimal v)          { this.awayOddsForm = v; }
}
