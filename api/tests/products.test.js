const request = require("supertest");

jest.mock("../src/db");
const db = require("../src/db");
const app = require("../src/app");

describe("GET /products", () => {
  test("retourne la liste des produits depuis la base", async () => {
    const rows = [
      {
        id: 1,
        name: "Clavier compact",
        description: "Clavier",
        price_cents: 5990
      }
    ];
    db.query.mockResolvedValueOnce({ rows });

    const response = await request(app).get("/products");

    expect(response.status).toBe(200);
    expect(response.body.source).toBe("database");
    expect(response.body.data).toHaveLength(1);
    expect(response.body.data[0].name).toBe("Clavier compact");
  });

  test("retourne 500 quand la base echoue", async () => {
    db.query.mockRejectedValueOnce(new Error("erreur base"));

    const response = await request(app).get("/products");

    expect(response.status).toBe(500);
    expect(response.body.error).toBe("Internal server error");
  });
});

describe("Routes inconnues", () => {
  test("retourne 404 sur une route non definie", async () => {
    const response = await request(app).get("/route-inexistante");

    expect(response.status).toBe(404);
    expect(response.body.error).toBe("Route not found");
  });
});
