package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import ec.edu.utn.golmundial.dto.estadisticas.SeleccionDTO;
import ec.edu.utn.golmundial.util.ApiConfig;
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

    // TODO: confirmar path real con Ariel (ej: /selecciones)
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
     * Actualiza los datos editables de una seleccion (RF10). Los campos
     * estadisticos (partidosJugados, puntos, golesFavor, etc.) NO se
     * envian: esos los calcula y actualiza el propio backend cuando se
     * registra un resultado (RF06), no se editan manualmente aqui.
     *
     * TODO: confirmar path con Ariel (ej: PUT /selecciones/{id})
     */
    public boolean actualizar(SeleccionDTO dto) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("nombre", dto.getNombre());
            body.put("codigoFifa", dto.getCodigoFifa());
            body.put("esAnfitrion", dto.getEsAnfitrion());
            body.put("idGrupo", dto.getIdGrupo());

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/selecciones/" + dto.getIdSeleccion())
                .request(MediaType.APPLICATION_JSON)
                .put(Entity.json(mapper.writeValueAsString(body)));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al actualizar seleccion id=" + dto.getIdSeleccion(), e);
            return false;
        }
    }
}
