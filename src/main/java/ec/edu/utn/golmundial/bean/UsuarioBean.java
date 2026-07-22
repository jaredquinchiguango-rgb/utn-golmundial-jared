package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.UsuarioDTO;
import ec.edu.utn.golmundial.service.estadisticas.UsuarioService;
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
public class UsuarioBean implements Serializable {

    @Inject private UsuarioService usuarioService;
    @Inject private LoginBean      loginBean; // para reenviar credenciales del admin (Basic Auth)

    private List<UsuarioDTO> usuarios;

    @PostConstruct
    public void init() {
        cargarUsuarios();
    }

    public void cargarUsuarios() {
        usuarios = usuarioService.listarTodos(loginBean.getCorreo(), loginBean.getClave());
    }

    public void cambiarEstado(UsuarioDTO usuario) {
        boolean nuevoEstado = !Boolean.TRUE.equals(usuario.getEstado());
        boolean exito = usuarioService.cambiarEstado(
                usuario.getIdUsuario(), nuevoEstado, loginBean.getCorreo(), loginBean.getClave());

        if (exito) {
            cargarUsuarios();
            msg(FacesMessage.SEVERITY_INFO, "Estado del usuario actualizado.");
        } else {
            msg(FacesMessage.SEVERITY_ERROR, "No se pudo actualizar el estado del usuario.");
        }
    }

    private void msg(FacesMessage.Severity nivel, String texto) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(nivel, texto, null));
    }

    public List<UsuarioDTO> getUsuarios() { return usuarios; }
}
