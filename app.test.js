const request = require('supertest');
const app = require('./app');

describe('API Endpoints', () => {
  let server;

  beforeAll(() => {
    // Start server before tests
    server = app.listen(0); // Use port 0 for random available port
  });

  afterAll((done) => {
    // Close server after all tests
    server.close(done);
  });

  test('GET / should return welcome message', async () => {
    const response = await request(server).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.body.message).toBe('Hello from CI/CD K8s Demo!');
  });

  test('GET /health should return healthy status', async () => {
    const response = await request(server).get('/health');
    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe('healthy');
  });
});