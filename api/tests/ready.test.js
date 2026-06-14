const request = require("supertest");

jest.mock("../src/db");
const db = require("../src/db");
const app = require("../src/app");

describe("GET /ready", () => {
  test("retourne 200 quand la base repond", async () => {
    db.query.mockResolvedValueOnce({ rows: [{ value: 1 }] });

    const response = await request(app).get("/ready");

    expect(response.status).toBe(200);
    expect(response.body.ready).toBe(true);
    expect(response.headers["x-request-id"]).toBeDefined();
  });

  test("retourne 503 quand la base est injoignable", async () => {
    db.query.mockRejectedValueOnce(new Error("connexion impossible"));

    const response = await request(app).get("/ready");

    expect(response.status).toBe(503);
    expect(response.body.ready).toBe(false);
    expect(response.body.reason).toBe("database unavailable");
  });
});
