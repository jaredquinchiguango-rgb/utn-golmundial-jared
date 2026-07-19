package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.FaseDTO;
import ec.edu.utn.golmundial.service.estadisticas.FaseService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class FaseBean implements Serializable {

    @Inject private FaseService faseService;

    private List<FaseDTO> fases;

    @PostConstruct
    public void init() {
        fases = faseService.listarTodas();
    }

    public List<FaseDTO> getFases() { return fases; }
}
