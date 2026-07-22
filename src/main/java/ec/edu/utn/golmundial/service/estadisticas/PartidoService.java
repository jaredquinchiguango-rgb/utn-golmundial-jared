package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import ec.edu.utn.golmundial.dto.estadisticas.PartidoDTO;
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
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@ApplicationScoped
public class PartidoService {

    private static final Logger LOG = Logger.getLogger(PartidoService.class.getName());

    // Formato EXACTO que exige el backend de Ariel al crear/editar
    // (confirmado en su codigo: SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")).
    // Si no coincide, el backend ignora la fecha en silencio (try/catch vacio).
    private static final DateTimeFormatter FORMATO_FECHA_BACKEND =
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");

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

    public boolean crear(Integer fifaMatchNumber, LocalDateTime fechaHoraUtc, String status,
                          Integer idPhase, Integer idVenue, Integer idGroup,
                          Integer idHomeTeam, Integer idAwayTeam,
                          BigDecimal homeOdds, BigDecimal drawOdds, BigDecimal awayOdds,
                          String emailAdmin, String passwordAdmin) {
        try {
            String bodyJson = mapper.writeValueAsString(
                construirBodyMatchInput(fifaMatchNumber, fechaHoraUtc, status, idPhase, idVenue,
                        idGroup, idHomeTeam, idAwayTeam, homeOdds, drawOdds, awayOdds));

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos")
                .request(MediaType.APPLICATION_JSON)
                .header("Authorization", BasicAuthUtil.buildHeader(emailAdmin, passwordAdmin))
                .post(Entity.json(bodyJson));

            return response.getStatus() == 201;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al crear partido", e);
            return false;
        }
    }

    public boolean actualizar(Integer idPartido, Integer fifaMatchNumber, LocalDateTime fechaHoraUtc,
                               String status, Integer idPhase, Integer idVenue, Integer idGroup,
                               Integer idHomeTeam, Integer idAwayTeam,
                               BigDecimal homeOdds, BigDecimal drawOdds, BigDecimal awayOdds,
                               String emailAdmin, String passwordAdmin) {
        try {
            String bodyJson = mapper.writeValueAsString(
                construirBodyMatchInput(fifaMatchNumber, fechaHoraUtc, status, idPhase, idVenue,
                        idGroup, idHomeTeam, idAwayTeam, homeOdds, drawOdds, awayOdds));

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos/" + idPartido)
                .request(MediaType.APPLICATION_JSON)
                .header("Authorization", BasicAuthUtil.buildHeader(emailAdmin, passwordAdmin))
                .put(Entity.json(bodyJson));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al actualizar partido id=" + idPartido, e);
            return false;
        }
    }

    /** PUT /partidos/{id}/resultado (RF11). El backend pone status="FINALIZADO" solo. */
    public boolean registrarResultado(Integer idPartido, Integer golesLocal, Integer golesVisitante,
                                       String emailAdmin, String passwordAdmin) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("homeGoals", golesLocal);
            body.put("awayGoals", golesVisitante);

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/partidos/" + idPartido + "/resultado")
                .request(MediaType.APPLICATION_JSON)
                .header("Authorization", BasicAuthUtil.buildHeader(emailAdmin, passwordAdmin))
                .put(Entity.json(mapper.writeValueAsString(body)));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al registrar resultado del partido id=" + idPartido, e);
            return false;
        }
    }

    private ObjectNode construirBodyMatchInput(Integer fifaMatchNumber, LocalDateTime fechaHoraUtc,
            String status, Integer idPhase, Integer idVenue, Integer idGroup,
            Integer idHomeTeam, Integer idAwayTeam,
            BigDecimal homeOdds, BigDecimal drawOdds, BigDecimal awayOdds) {
        ObjectNode body = mapper.createObjectNode();
        body.put("fifaMatchNumber", fifaMatchNumber);
        // Formato exacto exigido por el backend: "2026-07-05T18:00:00Z"
        body.put("matchDateTimeUtc", fechaHoraUtc != null ? fechaHoraUtc.format(FORMATO_FECHA_BACKEND) : null);
        body.put("status", status);
        if (idPhase != null) body.put("idPhase", idPhase); else body.putNull("idPhase");
        if (idVenue != null) body.put("idVenue", idVenue); else body.putNull("idVenue");
        if (idGroup != null) body.put("idGroup", idGroup); else body.putNull("idGroup");
        body.put("idHomeTeam", idHomeTeam);
        body.put("idAwayTeam", idAwayTeam);
        if (homeOdds != null) body.put("homeOdds", homeOdds);
        if (drawOdds != null) body.put("drawOdds", drawOdds);
        if (awayOdds != null) body.put("awayOdds", awayOdds);
        return body;
    }
}
