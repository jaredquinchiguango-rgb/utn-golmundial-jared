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
    @Inject private LoginBean        loginBean; // para reenviar credenciales (Basic Auth)

    private List<SeleccionDTO> selecciones;
    private List<GrupoDTO>     grupos;
    private SeleccionDTO       seleccionSeleccionada;
    private Integer            idGrupoSeleccionado;

    @PostConstruct
    public void init() {
        cargarSelecciones();
        grupos = grupoService.listarTodos();
    }

    public void cargarSelecciones() {
        selecciones = seleccionService.listarTodas();
    }

    public String prepararEditar(SeleccionDTO seleccion) {
        seleccionSeleccionada = seleccion;
        idGrupoSeleccionado = resolverIdGrupoPorNombre(seleccion.getNombreGrupo());
        return "/selecciones/editar?faces-redirect=true";
    }

    private Integer resolverIdGrupoPorNombre(String nombreGrupo) {
        if (nombreGrupo == null || grupos == null) return null;
        return grupos.stream()
                .filter(g -> nombreGrupo.equals(g.getNombre()))
                .map(GrupoDTO::getIdGrupo)
                .findFirst().orElse(null);
    }

    public String guardarEdicion() {
        // idConfederacion en null es seguro: el backend de Ariel no toca
        // ese campo cuando llega null (confirmado en su codigo fuente).
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
        seleccionSeleccionada = null;
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
}
