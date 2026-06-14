const request = require("supertest");
const app = require("../src/app");
const db = require("../src/db");

// Ce test interroge un vrai PostgreSQL. Il ne tourne qu'en CI, ou la variable
// RUN_DB_TESTS vaut 1 et ou une base est disponible via DATABASE_URL.
// En local il est ignore pour ne pas casser npm test sans base.
const runDbTests = process.env.RUN_DB_TESTS === "1";
const suite = runDbTests ? describe : describe.skip;

suite("Integration GET /products avec PostgreSQL", () => {
  afterAll(async () => {
    await db.getPool().end();
  });

  test("retourne les produits charges depuis init.sql", async () => {
    const response = await request(app).get("/products");

    expect(response.status).toBe(200);
    expect(response.body.source).toBe("database");
    expect(Array.isArray(response.body.data)).toBe(true);
    expect(response.body.data.length).toBeGreaterThan(0);
  });
});
