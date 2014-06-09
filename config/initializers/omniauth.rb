Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "jJvEuBffknw77kmytRvGtOEPE", "dpWGpgzJrRlx3JseSte2R7m482orpwhlnMTg8ncUT7aimAyaSq"
  provider :facebook, "315548825275528", "73535798f2229fddb5b9199d47ebaf51", scope: 'email', display: "popup"
end
