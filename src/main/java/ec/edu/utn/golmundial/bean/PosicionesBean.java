package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.GrupoDTO;
import ec.edu.utn.golmundial.service.estadisticas.GrupoService;
import jakarta.faces.context.FacesContext;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;

@Named
@ViewScoped
public class PosicionesBean implements Serializable {

    @Inject private GrupoService grupoService;

    private Integer  idGrupoParam; // bindeado por <f:viewParam name="id">
    private GrupoDTO grupo;

    /** preRenderView de grupos/posiciones.xhtml */
    public void cargar() {
        if (FacesContext.getCurrentInstance().isPostback()) {
            return;
        }
        if (idGrupoParam == null) {
            return;
        }
        grupo = grupoService.obtenerPosiciones(idGrupoParam);
    }

    public Integer  getIdGrupoParam()          { return idGrupoParam; }
    public void     setIdGrupoParam(Integer v) { this.idGrupoParam = v; }

    public GrupoDTO getGrupo() { return grupo; }
}
