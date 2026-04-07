# Chess position binder

[![Main Workflow](https://github.com/loloof64/ChessPositionsBinder/actions/workflows/main_workflow.yml/badge.svg)](https://github.com/loloof64/ChessPositionsBinder/actions/workflows/main_workflow.yml)

Store and classify your favorite chess positions.

You can also save/download them into/from your Dropbox account.

Note : changed the Dropbox connection workflow : you will probably need to move your current positions in your Dropbox Account from the `Applications/ChessPositionsBinder` to the folder `Applications/ChessPositionsBinder/positions` for them to be recognized by the application.

## For developers

### Locales

In order to update locales, run `dart run slang` from your terminal.

### Dropbox

1. Create a Dropbox account for the application on the Dropbox Console
2. Declare 2 redirects Uri

- http://localhost:53682 (will be used for Desktop)
- the page of your website where you redirect on application once the code providen (more below)

3. Create file `lib/dropbox_config.dart`

```dart
const appId = "<your_app_id>";
const redirectAdress =
    "<your_website_redirect_uri>";

```

4. Create and host a web page with the following content

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chess Positions Binder - Oauth2 redirect</title>
    <script>
      function init() {
        if (typeof window === "undefined") return;
        const hash = window.location.hash || "";
        const search = window.location.search || "";
        const params = hash || search;
        const scheme = "chess-positions-binder://oauth2redirect";
        const redirectUrl = scheme + params;

        // Add a link to close the application manually
        const manualLink = document.createElement("a");
        manualLink.href = redirectUrl;
        manualLink.textContent = "Close manually";
        manualLink.style.display = "block";
        manualLink.style.marginTop = "1em";
        document.body.appendChild(manualLink);

        // If opened as popup, send params back to opener; otherwise open app via deep link
        if (window.opener) {
          // Cherche le code d'abord dans la query, puis dans le hash
          let code = new URLSearchParams(window.location.search).get("code");
          if (!code && window.location.hash) {
            code = new URLSearchParams(
              window.location.hash.replace(/^#/, ""),
            ).get("code");
          }
          if (code) {
            window.opener.postMessage(
              { type: "oauth2_code", code },
              window.location.origin,
            );
          } else {
            window.opener.postMessage(
              { type: "oauth2_params", params },
              window.location.origin,
            );
          }
          window.close();
        } else {
          window.location.replace(redirectUrl);
        }
      }
    </script>
  </head>
  <body onload="init()">
    <div>
      <h1>Chess positions binder : Dropbox authentication</h1>
      <p>Returning to the app…</p>
    </div>
  </body>
</html>
```

And use its hosted adress as the alternative redirect Uri

5. Add the 2 repository Action secrets:

- DROPBOX_CLIENT_ID
- DROPBOX_REDIRECT_URI

so that the Github Action will be able to run correctly.

### Riverpod files generation

```bash
dart run build_runner watch -d
```

## Credits

### Tensorlow lite model

Using model from project [ChessCV](https://github.com/S1M0N38/chess-cv)
