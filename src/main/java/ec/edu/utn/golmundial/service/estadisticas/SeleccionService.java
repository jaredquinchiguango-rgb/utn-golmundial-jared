package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import ec.edu.utn.golmundial.dto.estadisticas.SeleccionDTO;
import ec.edu.utn.golmundial.util.ApiConfig;
import ec.edu.utn.golmundial.util.BasicAuthUtil;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@ApplicationScoped
public class SeleccionService {

    private static final Logger LOG = Logger.getLogger(SeleccionService.class.getName());

    private Client       client;
    private ObjectMapper mapper;

    @PostConstruct
    public void init() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
    }

    @PreDestroy
    public void destroy() {
        if (client != null) client.close();
    }

    /** GET, lectura abierta para invitados - no necesita Basic Auth. */
    public List<SeleccionDTO> listarTodas() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/selecciones")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<SeleccionDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar selecciones", e);
            return new ArrayList<>();
        }
    }

    /**
     * PUT, escritura - EXIGE Basic Auth de administrador.
     *
     * Nota sobre idConfederacion: confirmado en el codigo fuente de Ariel
     * que si se manda null, el backend simplemente NO TOCA ese campo (deja
     * el valor que ya tenia la seleccion) - no hace falta resolverlo,
     * mandar null aqui es seguro y es el comportamiento correcto mientras
     * no exista forma de saber cual es.
     */
    public boolean actualizar(SeleccionDTO dto, Integer idGrupo, Integer idConfederacion,
                               String emailAdmin, String passwordAdmin) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("name", dto.getNombre());
            body.put("fifaCode", dto.getCodigoFifa());
            body.put("isHost", dto.getEsAnfitrion());
            body.put("qualification", dto.getClasificacion());
            if (idGrupo != null) body.put("idGroup", idGrupo); else body.putNull("idGroup");
            if (idConfederacion != null) body.put("idConfederation", idConfederacion); else body.putNull("idConfederation");

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/selecciones/" + dto.getIdSeleccion())
                .request(MediaType.APPLICATION_JSON)
                .header("Authorization", BasicAuthUtil.buildHeader(emailAdmin, passwordAdmin))
                .put(Entity.json(mapper.writeValueAsString(body)));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al actualizar seleccion id=" + dto.getIdSeleccion(), e);
            return false;
        }
    }
}
