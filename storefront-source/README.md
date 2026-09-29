# NOOR Ring Storefront

A standalone React + Vite presale frontend inspired by the structure of the supplied Cybopal reference. This project is separate from the existing NOOR app demo and does not overwrite it.

## Run

```sh
npm install
npm run dev -- --host 0.0.0.0 --port 5180
```

## Verify

```sh
node --test tests/pricing.test.mjs
npm run build
```

## Included

- Product gallery, four finishes, size guide, quantity and sizing-kit selection.
- Chinese/English switching, with a browser-local language preference.
- USD pricing: $349 retail, $199 early bird with a $30 reservation deposit.
- Larger typography inspired by Cybopal: 18px desktop body and 48-56px section/product headings.
- Reservation form validation and local-only completion state.
- Original product video assets transcoded to H.264 for browser compatibility.
- Lifestyle imagery extracted from the supplied English product brochure.
- Wellness feature sections, planned app Qibla compass and prayer reminders.
- Responsive navigation, FAQ, privacy/terms preview and downloadable brochure.

## Before Publication

This is not a transactional store. No payment provider, database, email delivery, authentication, analytics or order API is connected. Form data is not transmitted or persisted. A completed preview is not a real reservation.

Confirm sizes, stock, subscription terms, deposit credits/refunds, shipping fees/dates, taxes, warranty, production specifications and privacy policy before enabling paid orders. Qibla and prayer reminders are explicitly marked as planned app features, not hardware capabilities.

Weight, dimensions and the water-resistance rating are brochure claims, not independently verified specifications. No medical, injury-prevention or accuracy guarantee is made. Confirm rights to publish supplied media before public launch.

## GitHub Pages

Public storefront: https://deenhuang.github.io/noor-ring-app-demo/store/

The original app demo remains at the repository root. Build for the storefront path with:

```sh
NOOR_BASE_PATH=/noor-ring-app-demo/store/ npm run build
```

Publish the contents of `dist/client` to the repository's `store` directory.
