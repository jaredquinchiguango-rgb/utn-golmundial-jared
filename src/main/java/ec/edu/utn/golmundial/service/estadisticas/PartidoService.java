package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import ec.edu.utn.golmundial.dto.estadisticas.PartidoDTO;
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
public class PartidoService {

    private static final Logger LOG = Logger.getLogger(PartidoService.class.getName());

    private Client       client;
    private ObjectMapper mapper;

    @PostConstruct
    public void init() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper().registerModule(new JavaTimeModule());
    }

    @PreDestroy
    public void destroy() {
        if (client != null) client.close();
    }

    // TODO: confirmar con Ariel el path exacto del endpoint (ej: /partidos)
    public List<PartidoDTO> listarTodos() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<PartidoDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar partidos", e);
            return new ArrayList<>();
        }
    }

    public PartidoDTO buscarPorId(Integer id) {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos/" + id)
                .request(MediaType.APPLICATION_JSON)
                .get();

            if (response.getStatus() == 404) return null;

            String json = response.readEntity(String.class);
            return mapper.readValue(json, PartidoDTO.class);

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al buscar partido id=" + id, e);
            return null;
        }
    }

    public boolean crear(PartidoDTO dto) {
        try {
            String bodyJson = mapper.writeValueAsString(construirBodyCrear(dto));
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos")
                .request(MediaType.APPLICATION_JSON)
                .post(Entity.json(bodyJson));

            return response.getStatus() == 201;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al crear partido", e);
            return false;
        }
    }

    public boolean actualizar(PartidoDTO dto) {
        try {
            String bodyJson = mapper.writeValueAsString(construirBodyCrear(dto));
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos/" + dto.getIdPartido())
                .request(MediaType.APPLICATION_JSON)
                .put(Entity.json(bodyJson));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al actualizar partido id=" + dto.getIdPartido(), e);
            return false;
        }
    }

    /**
     * Registra el resultado oficial de un partido (RF11). Al hacerlo, el
     * Servicio de Estadisticas es quien internamente notifica al Servicio
     * UTNGolCoin para liquidar las predicciones (RF12) - nosotros solo
     * llamamos a este endpoint, la logica de liquidacion no es nuestra.
     *
     * TODO: confirmar con Ariel el path exacto (puede ser PUT /partidos/{id}/resultado
     * o similar) y el nombre real de los campos del body.
     */
    public boolean registrarResultado(Integer idPartido, Integer golesLocal, Integer golesVisitante) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("golesLocal", golesLocal);
            body.put("golesVisitante", golesVisitante);

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos/" + idPartido + "/resultado")
                .request(MediaType.APPLICATION_JSON)
                .put(Entity.json(mapper.writeValueAsString(body)));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al registrar resultado del partido id=" + idPartido, e);
            return false;
        }
    }

    private ObjectNode construirBodyCrear(PartidoDTO dto) {
        ObjectNode body = mapper.createObjectNode();
        body.put("numeroPartidoFifa", dto.getNumeroPartidoFifa());
        body.put("idSeleccionLocal", dto.getIdSeleccionLocal());
        body.put("idSeleccionVisitante", dto.getIdSeleccionVisitante());
        body.put("idSede", dto.getIdSede());
        body.put("idFase", dto.getIdFase());
        body.put("idGrupo", dto.getIdGrupo());
        return body;
    }
}
