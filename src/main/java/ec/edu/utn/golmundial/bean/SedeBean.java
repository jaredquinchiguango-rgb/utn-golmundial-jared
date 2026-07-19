package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.SedeDTO;
import ec.edu.utn.golmundial.service.estadisticas.SedeService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class SedeBean implements Serializable {

    @Inject private SedeService sedeService;

    private List<SedeDTO> sedes;

    @PostConstruct
    public void init() {
        sedes = sedeService.listarTodas();
    }

    public List<SedeDTO> getSedes() { return sedes; }
}
