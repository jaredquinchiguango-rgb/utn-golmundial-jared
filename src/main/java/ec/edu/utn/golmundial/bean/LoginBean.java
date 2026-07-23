package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.UsuarioDTO;
import ec.edu.utn.golmundial.service.estadisticas.UsuarioService;
import jakarta.enterprise.context.SessionScoped;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;

@Named
@SessionScoped
public class LoginBean implements Serializable {

    @Inject
    private UsuarioService usuarioService;

    private String     correo;
    private String     clave;
    private UsuarioDTO usuarioActual;

    public String ingresar() {
        UsuarioDTO usuario = usuarioService.login(correo, clave);

        if (usuario == null) {
            clave = null;
            msg(FacesMessage.SEVERITY_ERROR, "Correo o clave incorrectos.");
            return null;
        }

        if (usuario.getNombreRol() == null || !"ADMINISTRADOR".equalsIgnoreCase(usuario.getNombreRol().trim())) {
            clave = null;
            msg(FacesMessage.SEVERITY_ERROR,
                "Esta cuenta no tiene permisos de administrador para acceder a este panel.");
            return null;
        }

        // OJO: aqui NO se borra "clave" tras un login exitoso a proposito.
        // GET /api/usuarios y todas las escrituras (crear/editar partido,
        // registrar resultado, editar seleccion) exigen Basic Auth en cada
        // peticion, asi que necesitamos conservarla en memoria del
        // servidor durante la sesion. Nunca se muestra en pantalla ni
        // se registra en logs.
        usuarioActual = usuario;
        return "/index?faces-redirect=true";
    }

    public String salir() {
        usuarioActual = null;
        correo = null;
        clave = null;
        return "/login?faces-redirect=true";
    }

    public boolean isAutenticado() {
        return usuarioActual != null;
    }

    /** Inicial del nombre del usuario, para el avatar del rail lateral. */
    public String getInicial() {
        if (usuarioActual == null || usuarioActual.getNombre() == null
                || usuarioActual.getNombre().isBlank()) {
            return "A";
        }
        return usuarioActual.getNombre().substring(0, 1).toUpperCase();
    }

    private void msg(FacesMessage.Severity nivel, String texto) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(nivel, texto, null));
    }

    public String     getCorreo()           { return correo; }
    public void       setCorreo(String v)   { this.correo = v; }

    public String     getClave()            { return clave; }
    public void       setClave(String v)    { this.clave = v; }

    public UsuarioDTO getUsuarioActual()    { return usuarioActual; }
}