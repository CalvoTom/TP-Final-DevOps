const request = require("supertest");

jest.mock("../src/db");
const db = require("../src/db");
const app = require("../src/app");

describe("GET /", () => {
  test("retourne le nom de l'API", async () => {
    const response = await request(app).get("/");

    expect(response.status).toBe(200);
    expect(response.body.name).toBe("ShopLite API");
  });
});

describe("GET /health", () => {
  test("retourne 200 quand la base repond", async () => {
    db.query.mockResolvedValueOnce({ rows: [{ value: 1 }] });

    const response = await request(app).get("/health");

    expect(response.status).toBe(200);
    expect(response.body.status).toBe("ok");
    expect(response.body.checks.database).toBe("ok");
    expect(response.body.version).toBeDefined();
    expect(response.body.timestamp).toBeDefined();
    expect(response.headers["x-request-id"]).toBeDefined();
  });

  test("retourne 503 quand la base est injoignable", async () => {
    db.query.mockRejectedValueOnce(new Error("connexion impossible"));

    const response = await request(app).get("/health");

    expect(response.status).toBe(503);
    expect(response.body.status).toBe("error");
    expect(response.body.checks.database).toBe("error");
  });
});
