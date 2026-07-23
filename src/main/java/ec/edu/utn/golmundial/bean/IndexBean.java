package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.PartidoDTO;
import ec.edu.utn.golmundial.dto.estadisticas.UsuarioDTO;
import ec.edu.utn.golmundial.service.estadisticas.PartidoService;
import ec.edu.utn.golmundial.service.estadisticas.UsuarioService;
import ec.edu.utn.golmundial.service.utncoin.BilleteraService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * KPIs de la pantalla de Inicio. Reutiliza los mismos services que ya
 * usan Partidos, Usuarios y Reportes - no agrega ninguna llamada nueva
 * al backend, solo resume datos que ya existen.
 */
@Named
@ViewScoped
public class IndexBean implements Serializable {

    @Inject private PartidoService    partidoService;
    @Inject private UsuarioService    usuarioService;
    @Inject private BilleteraService  billeteraService;
    @Inject private LoginBean         loginBean;

    private int        partidosProgramados;
    private int        partidosFinalizados;
    private int        usuariosActivos;
    private BigDecimal totalCirculante;

    @PostConstruct
    public void init() {
        List<PartidoDTO> partidos = partidoService.listarTodos();
        partidosProgramados = (int) partidos.stream()
                .filter(p -> "PROGRAMADO".equals(p.getEstado())).count();
        partidosFinalizados = (int) partidos.stream()
                .filter(p -> "FINALIZADO".equals(p.getEstado())).count();

        List<UsuarioDTO> usuarios = usuarioService.listarTodos(loginBean.getCorreo(), loginBean.getClave());
        usuariosActivos = (int) usuarios.stream()
                .filter(u -> Boolean.TRUE.equals(u.getEstado())).count();

        totalCirculante = billeteraService.obtenerTotalCirculante();
    }

    public int        getPartidosProgramados() { return partidosProgramados; }
    public int        getPartidosFinalizados() { return partidosFinalizados; }
    public int        getUsuariosActivos()     { return usuariosActivos; }
    public BigDecimal getTotalCirculante()     { return totalCirculante; }
}
