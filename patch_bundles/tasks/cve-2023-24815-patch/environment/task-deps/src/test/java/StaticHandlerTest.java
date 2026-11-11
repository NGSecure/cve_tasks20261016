import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.http.*;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.StaticHandler;
import io.vertx.junit5.VertxExtension;
import io.vertx.junit5.VertxTestContext;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;

import static org.junit.jupiter.api.Assertions.assertEquals;


@ExtendWith({VertxExtension.class})
public class StaticHandlerTest {
  private StaticHandler _handler;
  private HttpClient _client;
  private int _port;
  private final String _host = "localhost";
  private final static String FOLDER = "www";

  @BeforeEach
  public void setup(Vertx vertx, VertxTestContext tc) {
    this._client = vertx.createHttpClient();
    this._handler = StaticHandler.create(FOLDER);
    HttpServer server = vertx.createHttpServer();
    Router router = Router.router(vertx);
    router.route("/*").handler(this._handler);
    server.requestHandler(router);
    server.listen().onComplete(tc.succeeding(s -> {
      this._port = server.actualPort();
      tc.completeNow();
    }));
  }

  @Test
  public void valid(VertxTestContext tc) {
    this.get("/accessible.txt").onComplete(tc.succeeding(
        res -> {
          assertEquals(200, res.statusCode());
          tc.completeNow();
        }
    ));
  }

  @Test
  public void notFound(VertxTestContext tc) {
    this.get("/not_found.txt").onComplete(tc.succeeding(
        res -> {
          assertEquals(404, res.statusCode());
          tc.completeNow();
        }
    ));
  }

  @Test
  public void invalidSlash(VertxTestContext tc) {
    this.get("/../rootfile.txt").onComplete(tc.succeeding(
        res -> {
          assertEquals(404, res.statusCode());
          tc.completeNow();
        }
    ));
  }

  @Test
  public void invalidBackslash(VertxTestContext tc) {
    this.get("/..\\rootfile.txt").onComplete(tc.succeeding(
        res -> {
          assertEquals(404, res.statusCode());
          tc.completeNow();
        }
    ));
  }

  private Future<HttpClientResponse> get(String path) {
    return this._client.request(HttpMethod.GET, this._port, this._host, path)
        .compose(HttpClientRequest::send);
  }
}