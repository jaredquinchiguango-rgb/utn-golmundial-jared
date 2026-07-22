package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.GrupoDTO;
import ec.edu.utn.golmundial.dto.estadisticas.SeleccionDTO;
import ec.edu.utn.golmundial.service.estadisticas.GrupoService;
import ec.edu.utn.golmundial.service.estadisticas.SeleccionService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class SeleccionBean implements Serializable {

    @Inject private SeleccionService seleccionService;
    @Inject private GrupoService     grupoService;
    @Inject private LoginBean        loginBean;

    private List<SeleccionDTO> selecciones;
    private List<GrupoDTO>     grupos;
    private SeleccionDTO       seleccionSeleccionada;
    private Integer            idGrupoSeleccionado;

    // Bindeado por <f:viewParam name="id"> en selecciones/editar.xhtml
    private Integer idSeleccionParam;

    @PostConstruct
    public void init() {
        cargarSelecciones();
        grupos = grupoService.listarTodos();
    }

    public void cargarSelecciones() {
        selecciones = seleccionService.listarTodas();
    }

    public String prepararEditar(SeleccionDTO seleccion) {
        return "/selecciones/editar?faces-redirect=true&id=" + seleccion.getIdSeleccion();
    }

    /** preRenderView de selecciones/editar.xhtml - busca la seleccion por idSeleccionParam. */
    public void inicializarEdicion() {
        if (FacesContext.getCurrentInstance().isPostback()) {
            return;
        }
        if (idSeleccionParam == null) {
            msg(FacesMessage.SEVERITY_ERROR, "No se especifico la seleccion.");
            return;
        }
        seleccionSeleccionada = selecciones.stream()
                .filter(s -> idSeleccionParam.equals(s.getIdSeleccion()))
                .findFirst().orElse(null);

        if (seleccionSeleccionada == null) {
            msg(FacesMessage.SEVERITY_ERROR, "No se encontro la seleccion solicitada.");
            return;
        }
        idGrupoSeleccionado = resolverIdGrupoPorNombre(seleccionSeleccionada.getNombreGrupo());
    }

    private Integer resolverIdGrupoPorNombre(String nombreGrupo) {
        if (nombreGrupo == null || grupos == null) return null;
        return grupos.stream()
                .filter(g -> nombreGrupo.equals(g.getNombre()))
                .map(GrupoDTO::getIdGrupo)
                .findFirst().orElse(null);
    }

    public String guardarEdicion() {
        if (seleccionSeleccionada == null) {
            msg(FacesMessage.SEVERITY_ERROR, "No hay seleccion cargada para editar.");
            return null;
        }
        boolean exito = seleccionService.actualizar(seleccionSeleccionada, idGrupoSeleccionado, null,
                loginBean.getCorreo(), loginBean.getClave());
        if (exito) {
            cargarSelecciones();
            msg(FacesMessage.SEVERITY_INFO, "Seleccion actualizada correctamente.");
            return "/selecciones/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo actualizar la seleccion.");
        return null;
    }

    public String cancelar() {
        return "/selecciones/lista?faces-redirect=true";
    }

    private void msg(FacesMessage.Severity nivel, String texto) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(nivel, texto, null));
    }

    public List<SeleccionDTO> getSelecciones()                  { return selecciones; }
    public List<GrupoDTO>     getGrupos()                        { return grupos; }

    public SeleccionDTO getSeleccionSeleccionada()               { return seleccionSeleccionada; }
    public void         setSeleccionSeleccionada(SeleccionDTO v) { this.seleccionSeleccionada = v; }

    public Integer getIdGrupoSeleccionado()          { return idGrupoSeleccionado; }
    public void    setIdGrupoSeleccionado(Integer v) { this.idGrupoSeleccionado = v; }

    public Integer getIdSeleccionParam()          { return idSeleccionParam; }
    public void    setIdSeleccionParam(Integer v) { this.idSeleccionParam = v; }
}
