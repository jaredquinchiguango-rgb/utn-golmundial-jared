package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.GrupoDTO;
import ec.edu.utn.golmundial.service.estadisticas.GrupoService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class GrupoBean implements Serializable {

    @Inject private GrupoService grupoService;

    private List<GrupoDTO> grupos;

    @PostConstruct
    public void init() {
        grupos = grupoService.listarTodos();
    }

    public List<GrupoDTO> getGrupos() { return grupos; }
}
