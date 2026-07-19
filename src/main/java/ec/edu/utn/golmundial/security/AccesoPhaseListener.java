package ec.edu.utn.golmundial.security;

import ec.edu.utn.golmundial.bean.LoginBean;
import jakarta.faces.application.Application;
import jakarta.faces.context.FacesContext;
import jakarta.faces.event.PhaseEvent;
import jakarta.faces.event.PhaseId;
import jakarta.faces.event.PhaseListener;
import java.io.IOException;

/**
 * Todo este frontend es exclusivo del rol administrador (el publico general
 * entra por el frontend publico de Yurak). Por eso la regla es simple:
 * la unica vista publica es /login.xhtml; todo lo demas exige sesion
 * autenticada de administrador, o redirige a /login.xhtml.
 */
public class AccesoPhaseListener implements PhaseListener {

    @Override
    public PhaseId getPhaseId() {
        return PhaseId.RESTORE_VIEW;
    }

    @Override
    public void beforePhase(PhaseEvent event) {
        // No se necesita logica antes de restaurar la vista
    }

    @Override
    public void afterPhase(PhaseEvent event) {
        FacesContext context = event.getFacesContext();
        if (context.getViewRoot() == null) {
            return;
        }
        String viewId = context.getViewRoot().getViewId();

        boolean esVistaPublica = "/login.xhtml".equals(viewId);
        if (esVistaPublica) {
            return;
        }

        Application app = context.getApplication();
        LoginBean loginBean = app.evaluateExpressionGet(context, "#{loginBean}", LoginBean.class);

        try {
            if (!loginBean.isAutenticado()) {
                redirigir(context, "/login.xhtml");
            }
        } catch (IOException e) {
            // Si la redireccion falla, se deja continuar el ciclo de vida normal
        }
    }

    private void redirigir(FacesContext context, String ruta) throws IOException {
        String contextPath = context.getExternalContext().getRequestContextPath();
        context.getExternalContext().redirect(contextPath + ruta);
        context.responseComplete();
    }
}
