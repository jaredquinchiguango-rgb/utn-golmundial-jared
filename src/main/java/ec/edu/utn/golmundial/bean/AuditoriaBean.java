package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.AuditoriaDTO;
import ec.edu.utn.golmundial.service.estadisticas.AuditoriaService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Named
@ViewScoped
public class AuditoriaBean implements Serializable {

    @Inject private AuditoriaService auditoriaService;
    @Inject private LoginBean        loginBean;

    private List<AuditoriaDTO> registros;

    @PostConstruct
    public void init() {
        cargar();
    }

    public void cargar() {
        List<AuditoriaDTO> lista = auditoriaService.listarTodas(loginBean.getCorreo(), loginBean.getClave());
        // Mas reciente primero
        registros = lista.stream()
                .sorted(Comparator.comparing(
                        AuditoriaDTO::getFechaHora,
                        Comparator.nullsLast(Comparator.reverseOrder())))
                .collect(Collectors.toList());
    }

    public List<AuditoriaDTO> getRegistros() { return registros; }
}
