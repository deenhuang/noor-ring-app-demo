import test from 'node:test';
import assert from 'node:assert/strict';
import { prices, formatPrice, validateReservation } from '../src/reservation.mjs';

test('currency quotes match the provided pricing draft, not live conversion', () => {
  assert.equal(prices.USD.deposit, 30);
  assert.equal(prices.USD.launch, 199);
  assert.equal(prices.USD.retail, 349);
  assert.deepEqual(Object.keys(prices), ['USD']);
  assert.equal(prices.USD.founder, undefined);
  assert.equal(prices.USD.early, undefined);
});
test('prices retain an explicit currency identifier', () => {
  assert.equal(formatPrice('USD', 30), '$30 USD');
  assert.equal(formatPrice('USD', 199), '$199 USD');
});
test('reservation errors have a Chinese translation', () => {
  assert.match(validateReservation({ email: 'x', country: '', accepted: false }, 'zh'), /邮箱/);
});
test('a reservation requires email, country, and acknowledgment', () => {
  assert.ok(validateReservation({ email: 'x', country: '', accepted: false }));
  assert.ok(validateReservation({ email: 'a@b.com', country: 'Saudi Arabia', accepted: false }));
  assert.equal(validateReservation({ email: 'a@b.com', country: 'Saudi Arabia', accepted: true }), '');
});
