{ inputs, self, ... }:
{
  flake.homeModules.browsers =
    { pkgs, ... }:
    let
      lock-false = {
        Value = false;
        Status = "locked";
      };
      lock-true = {
        Value = true;
        Status = "locked";
      };
    in
    {
      programs.firefox = {
        enable = true;

        profiles.matt = {
          search = {
            default = "kagi";
            force = true;
            engines = {
              "kagi" = {
                urls = [{ template = "https://kagi.com/search?q={searchTerms}"; }];
                iconUpdateURL = "https://kagi.com/favicon.ico";
                definedAliases = [ "@k" ];
              };
              "google".metaData.hidden = true;
              "bing".metaData.hidden = true;
              "amazondotcom".metaData.hidden = true;
              "ebay".metaData.hidden = true;
              "wikipedia".metaData.hidden = true;
              "duckduckgo".metaData.hidden = true;
            };
          };
        };

        policies = {
          # Disable Mozilla telemetry and data collection
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableFirefoxScreenshots = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          NetworkPrediction = false;
          PasswordManagerEnabled = false;
          OfferToSaveLogins = false;
          CaptivePortal = false;

          # Autofill
          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;

          # HTTPS and TLS
          HttpsOnlyMode = "force_enabled";
          SSLVersionMin = "tls1.2";
          PostQuantumKeyAgreementEnabled = true;
          HttpAllowlist = [
            "http://localhost"
            "http://127.0.0.1"
          ];

          # Tracking protection
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };

          # Sanitize on shutdown
          SanitizeOnShutdown = {
            Cache = true;
            FormData = true;
            SiteSettings = true;
            OfflineApps = true;
          };

          # User messaging
          UserMessaging = {
            ExtensionRecommendations = false;
            UrlbarInterventions = false;
            SkipOnboarding = true;
            MoreFromMozilla = false;
          };

          # Disable sponsored suggestions
          FirefoxSuggest = {
            WebSuggestions = false;
            SponsoredSuggestions = false;
            ImproveSuggest = false;
            Locked = true;
          };

          # Extensions - block all except explicitly allowed
          ExtensionSettings = {
            "*".installation_mode = "blocked";
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
            "jid1-MnnxcxisBPnSXQ@jetpack" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
              installation_mode = "force_installed";
            };
            "{74145f27-f039-47ce-a470-a662b129930a}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
              installation_mode = "force_installed";
            };
            "FirefoxColor@mozilla.com" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-color/latest.xpi";
              installation_mode = "force_installed";
            };
            "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
              installation_mode = "force_installed";
            };
          };

          # Locked preferences (global, not per-profile)
          Preferences = {
            "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };

            # Disable Pocket and screenshots
            "extensions.pocket.enabled" = lock-false;
            "extensions.screenshots.disabled" = lock-true;

            # Disable sponsored content and suggestions
            "browser.topsites.contile.enabled" = lock-false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
            "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
            "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
            "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
            "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
            "browser.newtabpage.activity-stream.showSponsored" = lock-false;
            "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
            "browser.urlbar.suggest.quicksuggest.sponsored" = lock-false;
            "browser.urlbar.trending.featureGate" = lock-false;
            "browser.discovery.enabled" = lock-false;
            "app.shield.optoutstudies.enabled" = lock-false;

            # Disable search suggestions
            "browser.formfill.enable" = lock-false;
            "browser.search.suggest.enabled" = lock-false;
            "browser.search.suggest.enabled.private" = lock-false;
            "browser.urlbar.suggest.searches" = lock-false;
            "browser.urlbar.showSearchSuggestionsFirst" = lock-false;

            # Privacy and fingerprinting
            "privacy.globalprivacycontrol.enabled" = lock-true;
            "privacy.fingerprintingProtection" = lock-true;
            "privacy.clearOnShutdown_v2.cookiesAndStorage" = lock-true;
            "browser.privatebrowsing.forceMediaMemoryCache" = lock-true;
            "network.http.referer.XOriginTrimmingPolicy" = { Value = 2; Status = "locked"; };

            # Disable network prefetching
            "network.dns.disablePrefetch" = lock-true;
            "network.predictor.enabled" = lock-false;
            "network.http.speculative-parallel-limit" = { Value = 0; Status = "locked"; };
            "browser.places.speculativeConnect.enabled" = lock-false;

            # Security
            "pdfjs.enableScripting" = lock-false;
            "signon.formlessCapture.enabled" = lock-false;
            "dom.disable_window_move_resize" = lock-true;
            "devtools.debugger.remote-enabled" = lock-false;
            "security.ssl.require_safe_negotiation" = lock-true;
            "security.cert_pinning.enforcement_level" = { Value = 2; Status = "locked"; };
            "security.pki.crlite_mode" = { Value = 2; Status = "locked"; };
            "security.ssl.treat_unsafe_negotiation_as_broken" = lock-true;
            "browser.xul.error_pages.expert_bad_cert" = lock-true;
            "security.csp.reporting.enabled" = lock-false;

            # Disable safe browsing remote lookups (privacy tradeoff)
            "browser.safebrowsing.downloads.remote.enabled" = lock-false;

            # AI Browsing disabled
            "browser.ai.control.default" = "blocked";
            "browser.ai.control.linkPreviewKeyPoints" = "blocked";
            "browser.ai.control.pdfjsAltText" = "blocked";
            "browser.ai.control.sidebarChatbot" = "blocked";
            "browser.ai.control.smartTabGroups" = "blocked";
            "browser.ml.chat.enabled" = false;
            "browser.ml.chat.page" = false;
            "browser.ml.linkPreview.enabled" = false;
            "browser.tabs.groups.smart.enabled" = false;
            "browser.tabs.groups.smart.userEnabled" = false;
            # "browser.translations.enable" = false; # Local model only, so not a privacy concern
            "extensions.ml.enabled" = false;
            "pdfjs.enableAltText" = false;
          };
        };
      };

      programs.chromium = {
        enable = true;
      };
    };
}
