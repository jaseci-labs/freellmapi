graph layers {
    layer all { *; }
}

graph spaces {
    space freellmapi: node { "cli"; }
    space client: browser { "client"; }
    space server: node { "server"; }
    space shared: node { "shared"; }
    space client_dev: node {
        "client/eslint.config";
        "client/vite.config";
        "client/vitest.config";
        "client/vitest.setup-storage";
        client.scripts.*;
    }
    space freellmapi_dev: node { cli.*; }
}

graph import {
    server.src.lib.jshost ++> "server/src/routes/client-profiles" { NULL, plain }
    server.src.lib.jshost ++> server.src.services.auth { NULL, missing, plain }
    server.src.lib.jshost ++> "server/src/services/model-retirement" { plain }
    server.src.lib.jshost ++> "server/src/lib/tool-validate" { NULL, plain }
    server.src.lib.jshost ++> "server/src/lib/anthropic-documents" { plain, sub }
    server.src.lib.jshost ++> "server/src/lib/request-log" { NULL, missing, plain, sub }
    server.src.lib.jshost ++> "server/src/lib/system-prompt" { NULL, missing, plain }
    server.src.lib.jshost ++> "server/src/lib/custom-provider-cleanup" { missing }
    server.src.lib.jshost ++> "server/src/lib/process-safety-net" { missing }
    server.src.lib.jshost ++> server.src.lib.config { NULL, plain }
    server.src.lib.jshost ++> "server/src/lib/ttfb-budget" { NULL, plain, rx }
    server.src.lib.jshost ++> "server/src/lib/output-cap" { NULL, missing, rx }
    server.src.lib.jshost ++> "server/src/lib/error-redaction" { missing, rx }
    server.src.lib.jshost ++> "server/src/lib/one-time-code" { NULL }
    server.src.lib.jshost ++> "server/src/lib/task-type" { rx }
    server.src.lib.jshost ++> "server/src/lib/wake-detect" { plain }
    server.src.lib.jshost ++> "server/src/lib/attempt-trace" { NULL, plain }
    server.src.lib.jshost ++> "server/src/lib/served-model" { NULL, missing, sub }
    server.src.lib.jshost ++> server.src.lib.guardrails { NULL, missing, plain }
    server.src.lib.jshost ++> "server/src/lib/system-date" { plain, rx }
    "cli/src/config-files" --> "cli/src/config-files.test" {
        applyGeneratedFile,
        applyGeneratedFiles,
        renderFile,
    }
    cli.src.types --> "cli/src/config-files" { GeneratedFile, JsonArrayMerge }
    cli.src.detect --> cli.src.types { DetectedClient }
    cli.src.detect --> "cli/src/detect.test" { clientNotes, desktopAppPath, detectChatGptClient }
    cli.src.doctor --> "cli/src/doctor.test" {
        DEFAULT_PROBE_TIMEOUT_MS,
        claudeLayers,
        codexLayers,
        diagnose,
        exitCodeFor,
        managedSettingsDir,
        managedSettingsPaths,
        normalizeUrl,
        probeGateway,
        sameGateway,
    }
    cli.src.index --> "cli/src/index.test" {
        claudeLaunchEnv,
        codexArgs,
        main,
        parseArgs,
        resolvePinnedModel,
        unsupportedNodeVersion,
    }
    cli.src.models --> "cli/src/index.test" { UnknownModelError }
    cli.src.types --> "cli/src/index.test" { CatalogModel }
    "cli/src/config-files" --> cli.src.index { applyGeneratedFiles, printDryRunDiff }
    cli.src.detect --> cli.src.index { detectChatGptClient }
    cli.src.tools --> cli.src.index { getTool, tools }
    cli.src.models --> cli.src.index { ResolvedModel, resolveLaunchModel }
    cli.src.doctor --> cli.src.index {
        DOCTOR_TOOLS,
        ToolReport,
        diagnose,
        exitCodeFor,
        formatReport,
    }
    cli.src.keys --> cli.src.index { KeyCommandOptions, keysHelp, runKeys }
    cli.src.types --> cli.src.index { CatalogModel, GenerateContext }
    cli.src.detect --> cli.src.tools { clientNotes, detectChatGptClient }
    cli.src.types --> cli.src.tools { CatalogModel, GenerateContext, Generation, ToolDefinition }
    cli.src.types --> cli.src.models { CatalogModel }
    cli.src.index --> "cli/src/keys.test" { main, parseArgs }
    cli.src.models --> "cli/src/models.test" {
        UnknownModelError,
        contextWindowOf,
        defaultModelId,
        resolveLaunchModel,
    }
    cli.src.types --> "cli/src/models.test" { CatalogModel }
    cli.src.tools --> "cli/src/tools.test" { tools }
    "cli/src/config-files" --> "cli/src/tools.test" { renderFile }
    cli.src.types --> "cli/src/tools.test" { GenerateContext }
    client.src.i18n.index --> "client/src/components/auth-gate.desktop-browser.test" {
        I18nProvider,
    }
    "client/src/components/auth-gate" --> "client/src/components/auth-gate.desktop-browser.test" {
        AuthGate,
    }
    client.src.i18n.I18nProvider --> client.src.i18n.index { I18nProvider, I18nProviderProps }
    client.src.i18n.context --> client.src.i18n.index { I18nContextValue, useI18n }
    "client/src/i18n/locale-config" --> client.src.i18n.index {
        DEFAULT_LOCALE,
        Locale,
        SUPPORTED_LOCALES,
    }
    client.src.i18n.context --> client.src.i18n.I18nProvider { I18nContext, I18nContextValue }
    "client/src/i18n/locale-config" --> client.src.i18n.I18nProvider {
        DEFAULT_LOCALE,
        Locale,
        RTL_LOCALES,
        SUPPORTED_LOCALES,
    }
    "client/src/i18n/locale-config" --> client.src.i18n.context { DEFAULT_LOCALE, Locale }
    client.src.lib.api --> "client/src/components/auth-gate" {
        API_BASE,
        ApiError,
        UNAUTHORIZED_EVENT,
        apiFetch,
        setToken,
    }
    client.src.components.ui.button --> "client/src/components/auth-gate" { Button }
    "client/src/components/ui/field-error" --> "client/src/components/auth-gate" { FieldError }
    client.src.components.ui.input --> "client/src/components/auth-gate" { Input }
    "client/src/components/ui/password-input" --> "client/src/components/auth-gate" {
        PasswordInput,
    }
    client.src.components.ui.label --> "client/src/components/auth-gate" { Label }
    client.src.lib.validate --> "client/src/components/auth-gate" { isEmail }
    client.src.i18n.index --> "client/src/components/auth-gate" { useI18n }
    client.src.lib.toast --> "client/src/components/auth-gate" { toast }
    client.src.lib.utils --> client.src.components.ui.button { cn }
    client.src.lib.utils --> client.src.components.ui.input { cn }
    client.src.components.ui.input --> "client/src/components/ui/password-input" { Input }
    client.src.lib.utils --> "client/src/components/ui/password-input" { cn }
    client.src.lib.utils --> client.src.components.ui.label { cn }
    client.src.i18n.index --> "client/src/components/auth-gate.desktop.test" { I18nProvider }
    "client/src/components/auth-gate" --> "client/src/components/auth-gate.desktop.test" {
        AuthGate,
    }
    client.src.i18n.index --> "client/src/components/auth-gate.login-identifier.test" {
        I18nProvider,
    }
    "client/src/components/auth-gate" --> "client/src/components/auth-gate.login-identifier.test" {
        AuthGate,
    }
    client.src.i18n.index --> "client/src/components/auth-gate.oidc.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/auth-gate.oidc.test" { clearToken, getToken }
    "client/src/components/auth-gate" --> "client/src/components/auth-gate.oidc.test" { AuthGate }
    client.src.i18n.index --> "client/src/components/auth-gate.reset-signs-in.test" { I18nProvider }
    "client/src/components/auth-gate" --> "client/src/components/auth-gate.reset-signs-in.test" {
        AuthGate,
    }
    client.src.lib.api --> "client/src/components/auth-gate.reset-signs-in.test" { getToken }
    client.src.i18n.index --> "client/src/components/decision-models.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/decision-models.test" { apiFetch }
    client.src.lib.decision --> "client/src/components/decision-models.test" { DecisionModel }
    "client/src/components/decision-models" --> "client/src/components/decision-models.test" {
        DecisionModelsView,
    }
    "client/src/components/models-tabs" --> "client/src/components/decision-models.test" {
        ModelsTabs,
    }
    client.src.lib.api --> "client/src/components/decision-models" { apiFetch }
    client.src.components.ui.switch --> "client/src/components/decision-models" { Switch }
    client.src.components.ui.button --> "client/src/components/decision-models" { Button }
    client.src.components.ui.input --> "client/src/components/decision-models" { Input }
    client.src.components.ui.label --> "client/src/components/decision-models" { Label }
    client.src.components.ui.textarea --> "client/src/components/decision-models" { Textarea }
    client.src.components.ui.select --> "client/src/components/decision-models" {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue,
    }
    "client/src/components/empty-state" --> "client/src/components/decision-models" { EmptyState }
    client.src.components.ui.skeleton --> "client/src/components/decision-models" { CardSkeleton }
    "client/src/components/page-header" --> "client/src/components/decision-models" { PageHeader }
    "client/src/components/models-tabs" --> "client/src/components/decision-models" { ModelsTabs }
    "client/src/components/code-block" --> "client/src/components/decision-models" { CodeBlock }
    client.src.i18n.index --> "client/src/components/decision-models" { useI18n }
    client.src.lib.decision --> "client/src/components/decision-models" {
        DecisionModel,
        DecisionResult,
        decisionExampleCurl,
        parseOptions,
        topProbabilities,
    }
    client.src.lib.utils --> client.src.components.ui.switch { cn }
    client.src.lib.utils --> client.src.components.ui.textarea { cn }
    client.src.lib.utils --> client.src.components.ui.select { cn }
    client.src.lib.utils --> "client/src/components/empty-state" { cn }
    client.src.lib.utils --> client.src.components.ui.skeleton { cn }
    client.src.i18n.index --> "client/src/components/models-tabs" { useI18n }
    client.src.lib.utils --> "client/src/components/code-block" { cn }
    client.src.lib.highlight --> "client/src/components/code-block" { highlightCode }
    client.src.i18n.index --> "client/src/components/decision-routing-popover.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/decision-routing-popover.test" { apiFetch }
    client.src.lib.routing --> "client/src/components/decision-routing-popover.test" {
        DecisionRoutingStatus,
    }
    "client/src/components/decision-routing-popover" --> "client/src/components/decision-routing-popover.test" {
        DecisionRoutingPopover,
        DecisionSetupGuide,
    }
    client.src.i18n.index --> "client/src/components/decision-routing-popover" { useI18n }
    client.src.lib.api --> "client/src/components/decision-routing-popover" { apiFetch }
    client.src.components.ui.button --> "client/src/components/decision-routing-popover" { Button }
    client.src.components.ui.popover --> "client/src/components/decision-routing-popover" {
        Popover,
        PopoverContent,
        PopoverTrigger,
    }
    client.src.components.keys.shared --> "client/src/components/decision-routing-popover" {
        PLATFORMS,
    }
    client.src.lib.decision --> "client/src/components/decision-routing-popover" { DecisionModel }
    client.src.lib.routing --> "client/src/components/decision-routing-popover" {
        DecisionRoutingStatus,
    }
    client.src.lib.utils --> client.src.components.ui.popover { cn }
    shared.types --> client.src.components.keys.shared { ApiKeyModel, Platform, ProviderQuotaState }
    client.src.i18n.index --> client.src.components.keys.shared { useI18n }
    client.src.i18n.index --> "client/src/components/getting-started.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/getting-started.test" { apiFetch }
    "client/src/components/getting-started" --> "client/src/components/getting-started.test" {
        GettingStarted,
    }
    client.src.lib.api --> "client/src/components/getting-started" { apiFetch }
    client.src.lib.clipboard --> "client/src/components/getting-started" { copyText }
    client.src.lib.toast --> "client/src/components/getting-started" { toast }
    "client/src/components/api-usage" --> "client/src/components/getting-started" { apiBaseUrl }
    client.src.components.ui.button --> "client/src/components/getting-started" { Button }
    client.src.i18n.index --> "client/src/components/getting-started" { useI18n }
    "client/src/components/copy-button" --> "client/src/components/api-usage" { CopyButton }
    client.src.i18n.index --> "client/src/components/api-usage" { useI18n }
    client.src.lib.utils --> "client/src/components/copy-button" { cn }
    client.src.lib.clipboard --> "client/src/components/copy-button" { copyText }
    client.src.lib.toast --> "client/src/components/copy-button" { toast }
    client.src.i18n.index --> "client/src/components/copy-button" { useI18n }
    client.src.i18n.index --> "client/src/components/keys/add-key-form.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/keys/add-key-form.test" { apiFetch }
    shared.types --> "client/src/components/keys/add-key-form.test" { Platform }
    "client/src/components/keys/add-key-form" --> "client/src/components/keys/add-key-form.test" {
        AddKeyForm,
    }
    client.src.lib.api --> "client/src/components/keys/add-key-form" { apiFetch }
    client.src.components.ui.button --> "client/src/components/keys/add-key-form" { Button }
    client.src.components.ui.input --> "client/src/components/keys/add-key-form" { Input }
    client.src.components.ui.textarea --> "client/src/components/keys/add-key-form" { Textarea }
    client.src.components.ui.label --> "client/src/components/keys/add-key-form" { Label }
    "client/src/components/model-combobox" --> "client/src/components/keys/add-key-form" {
        ModelCombobox,
    }
    "client/src/components/ui/field-error" --> "client/src/components/keys/add-key-form" {
        FieldError,
    }
    shared.types --> "client/src/components/keys/add-key-form" { ApiKey, Platform }
    client.src.i18n.index --> "client/src/components/keys/add-key-form" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/add-key-form" { toast }
    client.src.lib.routing --> "client/src/components/keys/add-key-form" { FallbackEntry }
    "client/src/lib/model-scope-selection" --> "client/src/components/keys/add-key-form" {
        ScopeCandidate,
        scopeCandidates,
        shouldOfferModelPicker,
    }
    client.src.lib.search --> "client/src/components/keys/add-key-form" {
        SEARCH_PROVIDERS,
        invalidateSearchQueries,
    }
    client.src.components.keys.shared --> "client/src/components/keys/add-key-form" {
        GetKeyLink,
        LISTED_PLATFORMS,
        PLATFORMS,
    }
    client.src.components.ui.popover --> "client/src/components/model-combobox" {
        Popover,
        PopoverContent,
        PopoverTrigger,
    }
    client.src.components.tooltip --> "client/src/components/model-combobox" { Tooltip }
    client.src.i18n.index --> "client/src/components/model-combobox" { useI18n }
    client.src.lib.routing --> "client/src/lib/model-scope-selection" { FallbackEntry }
    client.src.i18n.index --> "client/src/components/keys/add-model-dialog.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/keys/add-model-dialog.test" { apiFetch }
    "client/src/components/keys/add-model-dialog" --> "client/src/components/keys/add-model-dialog.test" {
        AddModelDialog,
    }
    client.src.lib.api --> "client/src/components/keys/add-model-dialog" { apiFetch }
    client.src.lib.search --> "client/src/components/keys/add-model-dialog" {
        invalidateSearchQueries,
    }
    client.src.components.ui.dialog --> "client/src/components/keys/add-model-dialog" {
        Dialog,
        DialogClose,
        DialogPopup,
        DialogTitle,
    }
    client.src.components.ui.button --> "client/src/components/keys/add-model-dialog" { Button }
    client.src.components.ui.input --> "client/src/components/keys/add-model-dialog" { Input }
    client.src.components.ui.label --> "client/src/components/keys/add-model-dialog" { Label }
    client.src.components.ui.switch --> "client/src/components/keys/add-model-dialog" { Switch }
    "client/src/components/ui/field-error" --> "client/src/components/keys/add-model-dialog" {
        FieldError,
    }
    client.src.i18n.index --> "client/src/components/keys/add-model-dialog" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/add-model-dialog" { toast }
    client.src.components.keys.shared --> "client/src/components/keys/add-model-dialog" {
        CUSTOM_GROUP,
        LISTED_PLATFORMS,
    }
    client.src.lib.utils --> client.src.components.ui.dialog { cn }
    client.src.i18n.index --> "client/src/components/keys/apinex-checkin-notice.test" {
        I18nProvider,
    }
    "client/src/i18n/locale-config" --> "client/src/components/keys/apinex-checkin-notice.test" {
        Locale,
    }
    "client/src/components/keys/apinex-checkin-notice" --> "client/src/components/keys/apinex-checkin-notice.test" {
        ApinexCheckinNotice,
    }
    client.src.components.ui.button --> "client/src/components/keys/apinex-checkin-notice" {
        Button,
    }
    client.src.i18n.index --> "client/src/components/keys/apinex-checkin-notice" { useI18n }
    client.src.i18n.index --> "client/src/components/keys/custom-provider-section.input-type.test" {
        I18nProvider,
    }
    client.src.lib.api --> "client/src/components/keys/custom-provider-section.input-type.test" {
        apiFetch,
    }
    "client/src/components/keys/custom-provider-section" --> "client/src/components/keys/custom-provider-section.input-type.test" {
        CustomProviderSection,
    }
    client.src.lib.api --> "client/src/components/keys/custom-provider-section" { apiFetch }
    client.src.lib.search --> "client/src/components/keys/custom-provider-section" {
        invalidateSearchQueries,
    }
    client.src.components.ui.button --> "client/src/components/keys/custom-provider-section" {
        Button,
    }
    client.src.components.ui.input --> "client/src/components/keys/custom-provider-section" {
        Input,
    }
    client.src.components.ui.textarea --> "client/src/components/keys/custom-provider-section" {
        Textarea,
    }
    client.src.components.ui.label --> "client/src/components/keys/custom-provider-section" {
        Label,
    }
    client.src.components.ui.switch --> "client/src/components/keys/custom-provider-section" {
        Switch,
    }
    client.src.components.ui.select --> "client/src/components/keys/custom-provider-section" {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue,
    }
    "client/src/components/ui/field-error" --> "client/src/components/keys/custom-provider-section" {
        FieldError,
    }
    client.src.lib.validate --> "client/src/components/keys/custom-provider-section" { isHttpUrl }
    client.src.i18n.index --> "client/src/components/keys/custom-provider-section" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/custom-provider-section" { toast }
    "client/src/components/keys/discover-models-dialog" --> "client/src/components/keys/custom-provider-section" {
        DiscoverModelsDialog,
    }
    "client/src/components/keys/group-label-field" --> "client/src/components/keys/custom-provider-section" {
        GroupLabelField,
    }
    client.src.lib.api --> "client/src/components/keys/discover-models-dialog" { apiFetch }
    client.src.components.ui.button --> "client/src/components/keys/discover-models-dialog" {
        Button,
    }
    client.src.components.ui.dialog --> "client/src/components/keys/discover-models-dialog" {
        Dialog,
        DialogPopup,
        DialogTitle,
    }
    client.src.i18n.index --> "client/src/components/keys/discover-models-dialog" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/discover-models-dialog" { toast }
    client.src.lib.routing --> "client/src/components/keys/discover-models-dialog" { formatContext }
    client.src.lib.api --> "client/src/components/keys/group-label-field" { apiFetch }
    client.src.components.ui.input --> "client/src/components/keys/group-label-field" { Input }
    client.src.components.ui.label --> "client/src/components/keys/group-label-field" { Label }
    client.src.i18n.index --> "client/src/components/keys/group-label-field" { useI18n }
    shared.types --> "client/src/components/keys/group-label-field" { ApiKey }
    "client/src/lib/endpoint-groups" --> "client/src/components/keys/group-label-field" {
        existingGroupLabels,
    }
    shared.types --> "client/src/lib/endpoint-groups" { ApiKey }
    client.src.i18n.index --> "client/src/components/keys/custom-provider-section.modalities.test" {
        I18nProvider,
    }
    client.src.lib.api --> "client/src/components/keys/custom-provider-section.modalities.test" {
        apiFetch,
    }
    client.src.components.keys.shared --> "client/src/components/keys/custom-provider-section.modalities.test" {
        CUSTOM_MODEL_KIND_LABEL,
    }
    "client/src/components/keys/custom-provider-section" --> "client/src/components/keys/custom-provider-section.modalities.test" {
        CustomProviderSection,
    }
    client.src.i18n.index --> "client/src/components/keys/custom-provider-section.test" {
        I18nProvider,
    }
    client.src.lib.api --> "client/src/components/keys/custom-provider-section.test" { apiFetch }
    "client/src/components/keys/custom-provider-section" --> "client/src/components/keys/custom-provider-section.test" {
        CustomProviderSection,
    }
    client.src.i18n.index --> "client/src/components/keys/edit-key-dialog.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/keys/edit-key-dialog.test" { apiFetch }
    shared.types --> "client/src/components/keys/edit-key-dialog.test" { ApiKey }
    "client/src/components/keys/edit-key-dialog" --> "client/src/components/keys/edit-key-dialog.test" {
        EditKeyDialog,
    }
    "client/src/components/keys/cap-usage" --> "client/src/components/keys/edit-key-dialog.test" {
        capUsage,
    }
    "client/src/components/keys/edit-models-dialog" --> "client/src/components/keys/edit-key-dialog.test" {
        EditModelsDialog,
    }
    client.src.lib.api --> "client/src/components/keys/edit-key-dialog" { apiFetch }
    client.src.lib.search --> "client/src/components/keys/edit-key-dialog" {
        invalidateSearchQueries,
    }
    client.src.components.ui.button --> "client/src/components/keys/edit-key-dialog" { Button }
    client.src.components.ui.dialog --> "client/src/components/keys/edit-key-dialog" {
        Dialog,
        DialogClose,
        DialogPopup,
        DialogTitle,
    }
    "client/src/components/ui/field-error" --> "client/src/components/keys/edit-key-dialog" {
        FieldError,
    }
    client.src.components.ui.input --> "client/src/components/keys/edit-key-dialog" { Input }
    client.src.components.ui.label --> "client/src/components/keys/edit-key-dialog" { Label }
    shared.types --> "client/src/components/keys/edit-key-dialog" { ApiKey }
    client.src.i18n.index --> "client/src/components/keys/edit-key-dialog" { useI18n }
    client.src.components.keys.shared --> "client/src/components/keys/edit-key-dialog" { PLATFORMS }
    "client/src/components/keys/group-label-field" --> "client/src/components/keys/edit-key-dialog" {
        GroupLabelField,
    }
    "client/src/components/keys/cap-usage" --> "client/src/components/keys/edit-key-dialog" {
        capUsage,
    }
    client.src.lib.api --> "client/src/components/keys/edit-models-dialog" { apiFetch }
    client.src.components.ui.button --> "client/src/components/keys/edit-models-dialog" { Button }
    client.src.components.ui.dialog --> "client/src/components/keys/edit-models-dialog" {
        Dialog,
        DialogClose,
        DialogPopup,
        DialogTitle,
    }
    client.src.i18n.index --> "client/src/components/keys/edit-models-dialog" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/edit-models-dialog" { toast }
    client.src.lib.routing --> "client/src/components/keys/edit-models-dialog" {
        FallbackEntry,
        formatContext,
    }
    "client/src/lib/model-scope-selection" --> "client/src/components/keys/edit-models-dialog" {
        scopeCandidates,
    }
    shared.types --> "client/src/components/keys/edit-models-dialog" { ApiKey }
    client.src.i18n.index --> "client/src/components/keys/keyless-notice.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/keys/keyless-notice.test" { apiFetch }
    "client/src/components/keys/keyless-notice" --> "client/src/components/keys/keyless-notice.test" {
        KeylessNotice,
    }
    client.src.lib.api --> "client/src/components/keys/keyless-notice" { apiFetch }
    client.src.components.ui.button --> "client/src/components/keys/keyless-notice" { Button }
    client.src.i18n.index --> "client/src/components/keys/keyless-notice" { useI18n }
    client.src.i18n.index --> "client/src/components/keys/provider-checklist-signup.test" {
        I18nProvider,
    }
    client.src.lib.api --> "client/src/components/keys/provider-checklist-signup.test" { apiFetch }
    "client/src/components/keys/provider-checklist-section" --> "client/src/components/keys/provider-checklist-signup.test" {
        ProviderChecklistSection,
    }
    client.src.lib.api --> "client/src/components/keys/provider-checklist-section" { apiFetch }
    client.src.components.tooltip --> "client/src/components/keys/provider-checklist-section" {
        Tooltip,
    }
    client.src.i18n.index --> "client/src/components/keys/provider-checklist-section" { useI18n }
    client.src.components.keys.shared --> "client/src/components/keys/provider-checklist-section" {
        PLATFORMS,
    }
    client.src.i18n.index --> "client/src/components/keys/provider-list-add-another-key.test" {
        I18nProvider,
    }
    client.src.lib.api --> "client/src/components/keys/provider-list-add-another-key.test" {
        apiFetch,
    }
    "client/src/components/keys/provider-list" --> "client/src/components/keys/provider-list-add-another-key.test" {
        ProviderList,
    }
    shared.types --> "client/src/components/keys/provider-list-add-another-key.test" {
        ApiKey,
        Platform,
    }
    client.src.lib.api --> "client/src/components/keys/provider-list" { apiFetch }
    client.src.components.ui.button --> "client/src/components/keys/provider-list" {
        Button,
        buttonVariants,
    }
    "client/src/components/confirm-button" --> "client/src/components/keys/provider-list" {
        ConfirmButton,
    }
    client.src.components.ui.input --> "client/src/components/keys/provider-list" { Input }
    client.src.components.ui.switch --> "client/src/components/keys/provider-list" { Switch }
    client.src.components.ui.badge --> "client/src/components/keys/provider-list" { Badge }
    "client/src/components/ui/segmented-control" --> "client/src/components/keys/provider-list" {
        SegmentedControl,
    }
    "client/src/components/empty-state" --> "client/src/components/keys/provider-list" {
        EmptyState,
    }
    client.src.components.ui.skeleton --> "client/src/components/keys/provider-list" {
        TableSkeleton,
    }
    client.src.components.tooltip --> "client/src/components/keys/provider-list" { Tooltip }
    "client/src/components/ui/dropdown-menu" --> "client/src/components/keys/provider-list" {
        DropdownMenu,
        DropdownMenuCheckboxItem,
        DropdownMenuContent,
        DropdownMenuItem,
        DropdownMenuTrigger,
    }
    shared.types --> "client/src/components/keys/provider-list" { ApiKey, ApiKeyModel, Platform }
    client.src.lib.utils --> "client/src/components/keys/provider-list" {
        formatSqliteUtcToLocalTime,
    }
    client.src.i18n.index --> "client/src/components/keys/provider-list" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/provider-list" { toast }
    "client/src/lib/key-search" --> "client/src/components/keys/provider-list" { keyMatchesQuery }
    client.src.lib.clipboard --> "client/src/components/keys/provider-list" { copyText }
    client.src.components.keys.shared --> "client/src/components/keys/provider-list" {
        CUSTOM_GROUP,
        CUSTOM_MODEL_KIND_LABEL,
        HealthData,
        PLATFORMS,
        customModelDeleteKey,
        customModelDeletePath,
        statusDot,
        statusLabelKey,
    }
    "client/src/components/keys/quota-balance" --> "client/src/components/keys/provider-list" {
        balanceByKey,
    }
    "client/src/components/keys/apinex-checkin-notice" --> "client/src/components/keys/provider-list" {
        ApinexCheckinNotice,
    }
    "client/src/components/keys/discover-models-dialog" --> "client/src/components/keys/provider-list" {
        DiscoverModelsDialog,
    }
    "client/src/components/keys/add-endpoint-key-dialog" --> "client/src/components/keys/provider-list" {
        AddEndpointKeyDialog,
    }
    "client/src/components/keys/copy-key-dialog" --> "client/src/components/keys/provider-list" {
        CopyKeyDialog,
    }
    "client/src/components/keys/edit-key-dialog" --> "client/src/components/keys/provider-list" {
        EditKeyDialog,
    }
    "client/src/components/keys/edit-models-dialog" --> "client/src/components/keys/provider-list" {
        EditModelsDialog,
    }
    "client/src/components/keys/model-scope-dialog" --> "client/src/components/keys/provider-list" {
        ModelScopeDialog,
    }
    "client/src/components/keys/test-models-dialog" --> "client/src/components/keys/provider-list" {
        TestModelsDialog,
    }
    "client/src/components/keys/add-model-dialog" --> "client/src/components/keys/provider-list" {
        AddModelDialog,
    }
    "client/src/lib/endpoint-groups" --> "client/src/components/keys/provider-list" { groupHandle }
    client.src.lib.search --> "client/src/components/keys/provider-list" {
        SEARCH_PROVIDERS,
        invalidateSearchQueries,
        isSearchPlatform,
    }
    client.src.components.ui.button --> "client/src/components/confirm-button" { Button }
    client.src.lib.utils --> "client/src/components/confirm-button" { cn }
    client.src.i18n.index --> "client/src/components/confirm-button" { useI18n }
    client.src.lib.utils --> client.src.components.ui.badge { cn }
    client.src.lib.utils --> "client/src/components/ui/segmented-control" { cn }
    client.src.lib.utils --> "client/src/components/ui/dropdown-menu" { cn }
    shared.types --> "client/src/lib/key-search" { ApiKey }
    shared.types --> "client/src/components/keys/quota-balance" { ProviderQuotaState }
    client.src.lib.utils --> "client/src/components/keys/quota-balance" { sqliteUtcToIso }
    client.src.lib.api --> "client/src/components/keys/add-endpoint-key-dialog" { apiFetch }
    client.src.lib.search --> "client/src/components/keys/add-endpoint-key-dialog" {
        invalidateSearchQueries,
    }
    client.src.components.ui.button --> "client/src/components/keys/add-endpoint-key-dialog" {
        Button,
    }
    client.src.components.ui.dialog --> "client/src/components/keys/add-endpoint-key-dialog" {
        Dialog,
        DialogPopup,
        DialogTitle,
    }
    client.src.components.ui.input --> "client/src/components/keys/add-endpoint-key-dialog" {
        Input,
    }
    client.src.components.ui.label --> "client/src/components/keys/add-endpoint-key-dialog" {
        Label,
    }
    client.src.i18n.index --> "client/src/components/keys/add-endpoint-key-dialog" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/add-endpoint-key-dialog" { toast }
    client.src.components.ui.dialog --> "client/src/components/keys/copy-key-dialog" {
        Dialog,
        DialogPopup,
        DialogTitle,
    }
    client.src.components.ui.button --> "client/src/components/keys/copy-key-dialog" { Button }
    client.src.components.ui.input --> "client/src/components/keys/copy-key-dialog" { Input }
    client.src.components.ui.label --> "client/src/components/keys/copy-key-dialog" { Label }
    "client/src/components/ui/field-error" --> "client/src/components/keys/copy-key-dialog" {
        FieldError,
    }
    client.src.lib.api --> "client/src/components/keys/copy-key-dialog" { ApiError, apiFetch }
    client.src.lib.clipboard --> "client/src/components/keys/copy-key-dialog" { copyText }
    client.src.i18n.index --> "client/src/components/keys/copy-key-dialog" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/copy-key-dialog" { toast }
    "client/src/components/auth-gate" --> "client/src/components/keys/copy-key-dialog" {
        AuthStatus,
    }
    client.src.lib.api --> "client/src/components/keys/model-scope-dialog" { apiFetch }
    client.src.components.ui.button --> "client/src/components/keys/model-scope-dialog" { Button }
    client.src.components.ui.dialog --> "client/src/components/keys/model-scope-dialog" {
        Dialog,
        DialogPopup,
        DialogTitle,
    }
    client.src.components.ui.input --> "client/src/components/keys/model-scope-dialog" { Input }
    client.src.i18n.index --> "client/src/components/keys/model-scope-dialog" { useI18n }
    shared.types --> "client/src/components/keys/model-scope-dialog" { ApiKey }
    client.src.lib.api --> "client/src/components/keys/test-models-dialog" { apiFetch }
    client.src.components.ui.dialog --> "client/src/components/keys/test-models-dialog" {
        Dialog,
        DialogClose,
        DialogPopup,
        DialogTitle,
    }
    client.src.components.ui.button --> "client/src/components/keys/test-models-dialog" { Button }
    "client/src/components/empty-state" --> "client/src/components/keys/test-models-dialog" {
        EmptyState,
    }
    client.src.i18n.index --> "client/src/components/keys/test-models-dialog" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/test-models-dialog" { toast }
    client.src.lib.search --> "client/src/components/keys/test-models-dialog" { SearchEngine }
    client.src.lib.decision --> "client/src/components/keys/test-models-dialog" { DecisionModel }
    "client/src/lib/test-models" --> "client/src/components/keys/test-models-dialog" {
        MODEL_TEST_MIN_INTERVAL_MS,
        nowMs,
        selectTestableModels,
    }
    client.src.i18n.index --> "client/src/components/keys/provider-list-balance.test" {
        I18nProvider,
    }
    client.src.lib.api --> "client/src/components/keys/provider-list-balance.test" { apiFetch }
    "client/src/components/keys/provider-list" --> "client/src/components/keys/provider-list-balance.test" {
        ProviderList,
    }
    "client/src/components/keys/quota-balance" --> "client/src/components/keys/provider-list-balance.test" {
        balanceByKey,
    }
    shared.types --> "client/src/components/keys/provider-list-balance.test" {
        ApiKey,
        ProviderQuotaState,
    }
    client.src.i18n.index --> "client/src/components/keys/provider-list-search.test" {
        I18nProvider,
    }
    client.src.lib.api --> "client/src/components/keys/provider-list-search.test" { apiFetch }
    "client/src/components/keys/provider-list" --> "client/src/components/keys/provider-list-search.test" {
        ProviderList,
    }
    shared.types --> "client/src/components/keys/provider-list-search.test" { ApiKey, Platform }
    client.src.i18n.index --> "client/src/components/keys/provider-list-status-filter.test" {
        I18nProvider,
    }
    client.src.lib.api --> "client/src/components/keys/provider-list-status-filter.test" {
        apiFetch,
    }
    "client/src/components/keys/provider-list" --> "client/src/components/keys/provider-list-status-filter.test" {
        ProviderList,
    }
    shared.types --> "client/src/components/keys/provider-list-status-filter.test" { ApiKey }
    client.src.i18n.index --> "client/src/components/keys/provider-visibility.test" { I18nProvider }
    "client/src/components/keys/add-key-form" --> "client/src/components/keys/provider-visibility.test" {
        AddKeyForm,
    }
    "client/src/components/keys/add-model-dialog" --> "client/src/components/keys/provider-visibility.test" {
        AddModelDialog,
    }
    client.src.components.keys.shared --> "client/src/components/keys/provider-visibility.test" {
        LISTED_PLATFORMS,
        PLATFORMS,
    }
    client.src.i18n.index --> "client/src/components/keys/quota-signals-section.test" {
        I18nProvider,
    }
    client.src.lib.api --> "client/src/components/keys/quota-signals-section.test" { apiFetch }
    client.src.pages.KeysPage --> "client/src/components/keys/quota-signals-section.test" {
        default,
    }
    shared.types --> "client/src/components/keys/quota-signals-section.test" {
        ProviderQuotaState,
        QuotaOutlookPool,
        QuotaOutlookResponse,
    }
    client.src.lib.api --> client.src.pages.KeysPage { apiFetch }
    client.src.lib.search --> client.src.pages.KeysPage { invalidateSearchQueries }
    client.src.components.ui.button --> client.src.pages.KeysPage { Button }
    "client/src/components/ui/segmented-control" --> client.src.pages.KeysPage { SegmentedControl }
    "client/src/components/page-header" --> client.src.pages.KeysPage { PageHeader }
    shared.types --> client.src.pages.KeysPage { ApiKey, Platform }
    client.src.i18n.index --> client.src.pages.KeysPage { useI18n }
    client.src.components.keys.shared --> client.src.pages.KeysPage { HealthData, LISTED_PLATFORMS }
    "client/src/components/keys/quota-signals-section" --> client.src.pages.KeysPage {
        QuotaSignalsSection,
    }
    "client/src/components/keys/unified-key-section" --> client.src.pages.KeysPage {
        UnifiedKeySection,
    }
    "client/src/components/keys/client-profiles-section" --> client.src.pages.KeysPage {
        ClientProfilesSection,
    }
    "client/src/components/keys/proxy-settings-section" --> client.src.pages.KeysPage {
        ProxySettingsSection,
    }
    "client/src/components/keys/backups-section" --> client.src.pages.KeysPage { BackupsSection }
    "client/src/components/keys/anthropic-section" --> client.src.pages.KeysPage {
        AnthropicSection,
    }
    "client/src/components/keys/provider-list" --> client.src.pages.KeysPage { ProviderList }
    "client/src/components/keys/provider-checklist-section" --> client.src.pages.KeysPage {
        ProviderChecklistSection,
    }
    "client/src/components/keys/keyless-notice" --> client.src.pages.KeysPage { KeylessNotice }
    "client/src/components/keys/add-key-dialog" --> client.src.pages.KeysPage { AddKeyDialog }
    "client/src/components/keys/export-keys-dialog" --> client.src.pages.KeysPage {
        ExportKeysDialog,
    }
    "client/src/components/keys/agent-compatibility-section" --> client.src.pages.KeysPage {
        AgentCompatibilitySection,
    }
    shared.types --> "client/src/components/keys/quota-signals-section" { ProviderQuotaState }
    "client/src/components/empty-state" --> "client/src/components/keys/quota-signals-section" {
        EmptyState,
    }
    client.src.lib.utils --> "client/src/components/keys/quota-signals-section" {
        formatSqliteUtcToLocalTime,
    }
    client.src.i18n.index --> "client/src/components/keys/quota-signals-section" { useI18n }
    "client/src/components/keys/quota-outlook-section" --> "client/src/components/keys/quota-signals-section" {
        QuotaOutlookSection,
    }
    shared.types --> "client/src/components/keys/quota-outlook-section" {
        QuotaOutlookPool,
        QuotaOutlookResponse,
    }
    client.src.lib.api --> "client/src/components/keys/quota-outlook-section" { apiFetch }
    client.src.i18n.index --> "client/src/components/keys/quota-outlook-section" { useI18n }
    client.src.lib.utils --> "client/src/components/keys/quota-outlook-section" { cn }
    client.src.components.ui.badge --> "client/src/components/keys/quota-outlook-section" { Badge }
    client.src.components.ui.button --> "client/src/components/keys/quota-outlook-section" {
        Button,
    }
    client.src.components.keys.shared --> "client/src/components/keys/quota-outlook-section" {
        PLATFORMS,
    }
    client.src.lib.api --> "client/src/components/keys/unified-key-section" { apiFetch }
    client.src.lib.clipboard --> "client/src/components/keys/unified-key-section" { copyText }
    client.src.lib.toast --> "client/src/components/keys/unified-key-section" { toast }
    client.src.components.ui.button --> "client/src/components/keys/unified-key-section" { Button }
    "client/src/components/confirm-button" --> "client/src/components/keys/unified-key-section" {
        ConfirmButton,
    }
    client.src.i18n.index --> "client/src/components/keys/unified-key-section" { useI18n }
    client.src.lib.api --> "client/src/components/keys/client-profiles-section" { apiFetch }
    client.src.lib.clipboard --> "client/src/components/keys/client-profiles-section" { copyText }
    client.src.lib.toast --> "client/src/components/keys/client-profiles-section" { toast }
    client.src.components.ui.button --> "client/src/components/keys/client-profiles-section" {
        Button,
    }
    client.src.components.ui.input --> "client/src/components/keys/client-profiles-section" {
        Input,
    }
    client.src.components.ui.textarea --> "client/src/components/keys/client-profiles-section" {
        Textarea,
    }
    client.src.components.ui.switch --> "client/src/components/keys/client-profiles-section" {
        Switch,
    }
    "client/src/components/confirm-button" --> "client/src/components/keys/client-profiles-section" {
        ConfirmButton,
    }
    client.src.i18n.index --> "client/src/components/keys/client-profiles-section" { useI18n }
    client.src.lib.api --> "client/src/components/keys/proxy-settings-section" { apiFetch }
    client.src.components.ui.button --> "client/src/components/keys/proxy-settings-section" {
        Button,
    }
    client.src.components.ui.input --> "client/src/components/keys/proxy-settings-section" { Input }
    client.src.components.ui.label --> "client/src/components/keys/proxy-settings-section" { Label }
    client.src.components.ui.switch --> "client/src/components/keys/proxy-settings-section" {
        Switch,
    }
    client.src.components.ui.select --> "client/src/components/keys/proxy-settings-section" {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue,
    }
    client.src.i18n.index --> "client/src/components/keys/proxy-settings-section" { useI18n }
    client.src.components.keys.shared --> "client/src/components/keys/proxy-settings-section" {
        CUSTOM_GROUP,
        PLATFORMS,
    }
    shared.types --> "client/src/components/keys/proxy-settings-section" { ApiKey, ProxyMode }
    client.src.lib.api --> "client/src/components/keys/backups-section" { apiFetch, getToken }
    client.src.lib.toast --> "client/src/components/keys/backups-section" { toast }
    client.src.components.ui.button --> "client/src/components/keys/backups-section" { Button }
    client.src.components.ui.input --> "client/src/components/keys/backups-section" { Input }
    client.src.components.ui.label --> "client/src/components/keys/backups-section" { Label }
    client.src.components.ui.switch --> "client/src/components/keys/backups-section" { Switch }
    client.src.components.ui.badge --> "client/src/components/keys/backups-section" { Badge }
    "client/src/components/confirm-button" --> "client/src/components/keys/backups-section" {
        ConfirmButton,
    }
    client.src.i18n.index --> "client/src/components/keys/backups-section" { useI18n }
    client.src.lib.api --> "client/src/components/keys/anthropic-section" { apiFetch }
    client.src.components.ui.button --> "client/src/components/keys/anthropic-section" { Button }
    client.src.components.ui.select --> "client/src/components/keys/anthropic-section" {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue,
    }
    client.src.i18n.index --> "client/src/components/keys/anthropic-section" { useI18n }
    client.src.components.ui.dialog --> "client/src/components/keys/add-key-dialog" {
        Dialog,
        DialogClose,
        DialogPopup,
        DialogTitle,
    }
    "client/src/components/ui/segmented-control" --> "client/src/components/keys/add-key-dialog" {
        SegmentedControl,
    }
    client.src.i18n.index --> "client/src/components/keys/add-key-dialog" { useI18n }
    shared.types --> "client/src/components/keys/add-key-dialog" { Platform }
    "client/src/components/keys/add-key-form" --> "client/src/components/keys/add-key-dialog" {
        AddKeyForm,
        AddedKeyScopeOffer,
    }
    "client/src/components/keys/import-keys-section" --> "client/src/components/keys/add-key-dialog" {
        ImportKeysSection,
    }
    "client/src/components/keys/custom-provider-section" --> "client/src/components/keys/add-key-dialog" {
        CustomProviderSection,
    }
    "client/src/components/keys/model-select-dialog" --> "client/src/components/keys/add-key-dialog" {
        ModelSelectDialog,
    }
    client.src.lib.api --> "client/src/components/keys/import-keys-section" { apiFetch }
    client.src.lib.search --> "client/src/components/keys/import-keys-section" {
        invalidateSearchQueries,
    }
    client.src.components.ui.button --> "client/src/components/keys/import-keys-section" { Button }
    client.src.components.ui.input --> "client/src/components/keys/import-keys-section" { Input }
    client.src.components.ui.label --> "client/src/components/keys/import-keys-section" { Label }
    client.src.components.ui.select --> "client/src/components/keys/import-keys-section" {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue,
    }
    client.src.components.ui.table --> "client/src/components/keys/import-keys-section" {
        Table,
        TableBody,
        TableCell,
        TableHead,
        TableHeader,
        TableRow,
    }
    shared.types --> "client/src/components/keys/import-keys-section" {
        ImportKey,
        ImportSelectedResponse,
        Platform,
        PreviewKey,
        PreviewResponse,
    }
    client.src.i18n.index --> "client/src/components/keys/import-keys-section" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/import-keys-section" { toast }
    client.src.components.keys.shared --> "client/src/components/keys/import-keys-section" {
        CUSTOM_GROUP,
        LISTED_PLATFORMS,
    }
    client.src.lib.utils --> client.src.components.ui.table { cn }
    client.src.lib.api --> "client/src/components/keys/model-select-dialog" { apiFetch }
    client.src.components.ui.button --> "client/src/components/keys/model-select-dialog" { Button }
    client.src.components.ui.dialog --> "client/src/components/keys/model-select-dialog" {
        Dialog,
        DialogPopup,
        DialogTitle,
    }
    client.src.i18n.index --> "client/src/components/keys/model-select-dialog" { useI18n }
    client.src.lib.toast --> "client/src/components/keys/model-select-dialog" { toast }
    client.src.lib.routing --> "client/src/components/keys/model-select-dialog" { formatContext }
    "client/src/lib/model-scope-selection" --> "client/src/components/keys/model-select-dialog" {
        ScopeCandidate,
        resolveScopeUpdate,
    }
    client.src.components.ui.dialog --> "client/src/components/keys/export-keys-dialog" {
        Dialog,
        DialogClose,
        DialogPopup,
        DialogTitle,
    }
    client.src.components.ui.button --> "client/src/components/keys/export-keys-dialog" { Button }
    client.src.components.ui.label --> "client/src/components/keys/export-keys-dialog" { Label }
    client.src.components.ui.switch --> "client/src/components/keys/export-keys-dialog" { Switch }
    client.src.components.ui.input --> "client/src/components/keys/export-keys-dialog" { Input }
    "client/src/components/ui/field-error" --> "client/src/components/keys/export-keys-dialog" {
        FieldError,
    }
    client.src.i18n.index --> "client/src/components/keys/export-keys-dialog" { useI18n }
    client.src.lib.api --> "client/src/components/keys/export-keys-dialog" {
        ApiError,
        apiFetch,
        getToken,
    }
    client.src.lib.toast --> "client/src/components/keys/export-keys-dialog" { toast }
    "client/src/components/auth-gate" --> "client/src/components/keys/export-keys-dialog" {
        AuthStatus,
    }
    shared.types --> "client/src/components/keys/export-keys-dialog" { ApiKey }
    client.src.lib.api --> "client/src/components/keys/agent-compatibility-section" { apiFetch }
    client.src.i18n.index --> "client/src/components/keys/agent-compatibility-section" { useI18n }
    client.src.components.ui.button --> "client/src/components/keys/agent-compatibility-section" {
        Button,
    }
    client.src.components.ui.input --> "client/src/components/keys/agent-compatibility-section" {
        Input,
    }
    client.src.components.ui.select --> "client/src/components/keys/agent-compatibility-section" {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue,
    }
    client.src.components.ui.switch --> "client/src/components/keys/agent-compatibility-section" {
        Switch,
    }
    "client/src/components/copy-button" --> "client/src/components/keys/agent-compatibility-section" {
        CopyButton,
    }
    client.src.i18n.index --> "client/src/components/keys/search-readiness-cache.test" {
        I18nProvider,
    }
    client.src.lib.api --> "client/src/components/keys/search-readiness-cache.test" { apiFetch }
    "client/src/hooks/use-search-readiness" --> "client/src/components/keys/search-readiness-cache.test" {
        useSearchReadiness,
    }
    client.src.lib.search --> "client/src/components/keys/search-readiness-cache.test" {
        SearchEngine,
        SearchReadiness,
        invalidateSearchQueries,
    }
    "client/src/components/keys/add-key-form" --> "client/src/components/keys/search-readiness-cache.test" {
        AddKeyForm,
    }
    client.src.lib.api --> "client/src/hooks/use-search-readiness" { apiFetch }
    client.src.lib.search --> "client/src/hooks/use-search-readiness" {
        SearchEngine,
        SearchReadiness,
        engineChain,
    }
    client.src.i18n.index --> "client/src/components/keys/test-models-dialog.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/keys/test-models-dialog.test" { apiFetch }
    client.src.lib.toast --> "client/src/components/keys/test-models-dialog.test" { toast }
    "client/src/components/keys/test-models-dialog" --> "client/src/components/keys/test-models-dialog.test" {
        TestModelsDialog,
    }
    "client/src/lib/test-models" --> "client/src/components/keys/test-models-dialog.test" {
        selectTestableModels,
    }
    client.src.i18n.index --> "client/src/components/keys/unified-key-section.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/keys/unified-key-section.test" { apiFetch }
    "client/src/components/keys/unified-key-section" --> "client/src/components/keys/unified-key-section.test" {
        UnifiedKeySection,
    }
    "client/src/components/model-table" --> "client/src/components/model-table.range-bar.test" {
        AxisRangeBar,
    }
    client.src.i18n.index --> "client/src/components/model-table" { useI18n }
    "client/src/components/copy-button" --> "client/src/components/model-table" { CopyButton }
    client.src.components.ui.switch --> "client/src/components/model-table" { Switch }
    client.src.components.tooltip --> "client/src/components/model-table" { Tooltip }
    client.src.lib.routing --> "client/src/components/model-table" {
        ModelGroupRow,
        RateLimitUsageRow,
        Row,
        cleanQuotaLabel,
        formatContext,
        formatTokens,
        groupMaxContext,
        groupQuotaBadge,
        isGroupDepleted,
        memberEndpointTitle,
        memberProviderLabel,
        providerLabel,
        tightestRateLimit,
    }
    client.src.i18n.index --> "client/src/components/model-table.rank.test" { I18nProvider }
    "client/src/components/model-table" --> "client/src/components/model-table.rank.test" {
        SortableGroupRow,
    }
    client.src.lib.routing --> "client/src/components/model-table.rank.test" { ModelGroupRow }
    "client/src/components/playground/liquid-composer" --> "client/src/components/playground/liquid-composer.test" {
        LiquidComposer,
        LiquidComposerProps,
    }
    client.src.components.ui.button --> "client/src/components/playground/liquid-composer" {
        buttonVariants,
    }
    "client/src/components/ui/dropdown-menu" --> "client/src/components/playground/liquid-composer" {
        DropdownMenu,
        DropdownMenuContent,
        DropdownMenuItem,
        DropdownMenuSeparator,
        DropdownMenuTrigger,
    }
    client.src.components.ui.switch --> "client/src/components/playground/liquid-composer" {
        Switch,
    }
    "client/src/components/playground/dictation-button" --> "client/src/components/playground/liquid-composer" {
        DictationButton,
        DictationButtonProps,
        DictationPhase,
    }
    "client/src/components/playground/dictation-wave" --> "client/src/components/playground/liquid-composer" {
        DictationWave,
    }
    "client/src/lib/composer-geometry" --> "client/src/components/playground/liquid-composer" {
        COMPOSER_BRIDGE,
        COMPOSER_CORNER_PX,
        COMPOSER_EDGE,
        composerHeight,
        sendButtonInteractive,
        sendButtonOffset,
    }
    client.src.components.ui.button --> "client/src/components/playground/dictation-button" {
        Button,
    }
    client.src.i18n.index --> "client/src/components/playground/dictation-button" { useI18n }
    client.src.lib.toast --> "client/src/components/playground/dictation-button" { toast }
    client.src.lib.transcription --> "client/src/components/playground/dictation-button" {
        pickRecordingMimeType,
        recordingFilename,
    }
    "client/src/components/model-combobox" --> client.src.lib.transcription { ModelComboOption }
    client.src.lib.waveform --> "client/src/components/playground/dictation-wave" {
        WAVE_BAR_COUNT,
        barHeights,
    }
    client.src.i18n.index --> "client/src/components/search-engines.test" { I18nProvider }
    client.src.lib.api --> "client/src/components/search-engines.test" { apiFetch }
    client.src.lib.search --> "client/src/components/search-engines.test" { SearchEngine }
    "client/src/components/search-engines" --> "client/src/components/search-engines.test" {
        SearchEnginesView,
    }
    client.src.lib.api --> "client/src/components/search-engines" { apiFetch }
    client.src.components.ui.switch --> "client/src/components/search-engines" { Switch }
    client.src.components.ui.skeleton --> "client/src/components/search-engines" { CardSkeleton }
    "client/src/components/page-header" --> "client/src/components/search-engines" { PageHeader }
    "client/src/components/models-tabs" --> "client/src/components/search-engines" { ModelsTabs }
    "client/src/components/usage-summary-card" --> "client/src/components/search-engines" {
        UsageSummaryCard,
    }
    client.src.i18n.index --> "client/src/components/search-engines" { useI18n }
    client.src.lib.search --> "client/src/components/search-engines" {
        SearchAnalytics,
        SearchEngine,
        engineChain,
        freeFromDate,
        invalidateSearchQueries,
    }
    "client/src/hooks/use-search-readiness" --> "client/src/components/search-engines" {
        useSearchReadiness,
    }
    "client/src/components/search-readiness-notice" --> "client/src/components/search-engines" {
        SearchReadinessNotice,
    }
    client.src.i18n.index --> "client/src/components/usage-summary-card" { useI18n }
    client.src.lib.routing --> "client/src/components/usage-summary-card" {
        formatTokens,
        platformColors,
    }
    client.src.i18n.index --> "client/src/components/search-readiness-notice" { useI18n }
    client.src.lib.search --> "client/src/components/search-readiness-notice" {
        SearchReadiness,
        searchReadinessHint,
    }
    client.src.i18n.index --> "client/src/components/settings-start-at-login.test" { I18nProvider }
    client.src.theme --> "client/src/components/settings-start-at-login.test" { ThemeProvider }
    "client/src/components/settings-dialog" --> "client/src/components/settings-start-at-login.test" {
        SettingsDialog,
    }
    "client/src/theme-context" --> client.src.theme { Theme, ThemeContext }
    client.src.components.ui.dialog --> "client/src/components/settings-dialog" {
        Dialog,
        DialogClose,
        DialogPopup,
        DialogTitle,
    }
    client.src.components.ui.popover --> "client/src/components/settings-dialog" {
        Popover,
        PopoverContent,
        PopoverTrigger,
    }
    client.src.components.ui.switch --> "client/src/components/settings-dialog" { Switch }
    client.src.components.tooltip --> "client/src/components/settings-dialog" { Tooltip }
    client.src.i18n.index --> "client/src/components/settings-dialog" {
        Locale,
        SUPPORTED_LOCALES,
        useI18n,
    }
    "client/src/theme-context" --> "client/src/components/settings-dialog" { Theme, useTheme }
    client.src.lib.api --> "client/src/components/settings-dialog" { apiFetch }
    "client/src/lib/desktop-login-item" --> "client/src/components/settings-dialog" {
        useDesktopLoginItem,
    }
    client.src.i18n.index --> "client/src/components/settings-system-date.test" { I18nProvider }
    client.src.theme --> "client/src/components/settings-system-date.test" { ThemeProvider }
    "client/src/components/settings-dialog" --> "client/src/components/settings-system-date.test" {
        SettingsDialog,
    }
    "client/src/lib/alias-merge" --> "client/src/lib/alias-merge.test" {
        AliasMerge,
        addAlias,
        aliasesFor,
        normalizeInto,
        removeAlias,
    }
    client.src.lib.api --> "client/src/lib/api.test";
    "client/src/lib/artifact-panel-size" --> "client/src/lib/artifact-panel-size.test" {
        ARTIFACT_MIN_WIDTH,
        CHAT_MIN_WIDTH,
        clampArtifactWidth,
        defaultArtifactWidth,
        draggedArtifactWidth,
        maxArtifactWidth,
        readArtifactWidth,
    }
    client.src.lib.artifacts --> "client/src/lib/artifacts.test" {
        ARTIFACT_SANDBOX,
        artifactKindOf,
        artifactSrcDoc,
        extractArtifacts,
    }
    client.src.lib.attachments --> "client/src/lib/attachments.test" {
        Attachment,
        MAX_IMAGE_EDGE,
        attachmentImages,
        classifyFile,
        composeText,
        dataUrlBytes,
        fenceLanguage,
        fitWithin,
        inlineTextAttachment,
        toMessageContent,
    }
    "client/src/lib/budget-legend" --> "client/src/lib/budget-legend.test" {
        LegendModel,
        buildBudgetLegend,
        sortByIntelligence,
    }
    client.src.lib.routing --> "client/src/lib/budget-legend" { TokenUsageData }
    "client/src/lib/chart-axis" --> "client/src/lib/chart-axis.render.test" {
        categoryAxisProps,
        verticalCategoryAxisProps,
    }
    "client/src/lib/chart-axis" --> "client/src/lib/chart-axis.test" {
        CategoryAxisProps,
        MAX_AXIS_LABEL,
        MAX_AXIS_LABEL_STEEP,
        VERTICAL_AXIS_WIDTH,
        categoryAxisProps,
        truncateAxisLabel,
        verticalCategoryAxisProps,
    }
    client.src.lib.clipboard --> "client/src/lib/clipboard.test" { copyText }
    "client/src/lib/composer-geometry" --> "client/src/lib/composer-geometry.test" {
        COMPOSER_BUTTON_PX,
        COMPOSER_GAP_PX,
        COMPOSER_MAX_HEIGHT_PX,
        composerHasContent,
        composerHeight,
        sendButtonInteractive,
        sendButtonOffset,
    }
    client.src.lib.decision --> "client/src/lib/decision.test" {
        decisionExampleCurl,
        parseOptions,
        topProbabilities,
    }
    "client/src/lib/fusion-filter" --> "client/src/lib/fusion-filter.test" {
        filterFusionModels,
        fusionProviders,
    }
    "client/src/lib/model-groups" --> "client/src/lib/fusion-filter.test" { ModelOption }
    "client/src/lib/model-groups" --> "client/src/lib/fusion-filter" { ModelOption }
    client.src.lib.highlight --> "client/src/lib/highlight.test" {
        escapeHtml,
        highlightCode,
        resolveLanguage,
    }
    shared.types --> "client/src/lib/key-search.test" { ApiKey }
    "client/src/lib/key-search" --> "client/src/lib/key-search.test" { keyMatchesQuery }
    client.src.lib.logs --> "client/src/lib/logs.test" {
        LogEntry,
        LogLevel,
        advanceCursor,
        buildLogsQuery,
        clampMessage,
        collectEvents,
        collectProviders,
        formatLogTime,
        isLongMessage,
        levelsCsv,
        mergeEntries,
        toggleLevel,
    }
    "client/src/lib/model-maker" --> "client/src/lib/model-maker.test" { modelMakerOf }
    "client/src/lib/model-scope-selection" --> "client/src/lib/model-scope-selection.test" {
        MODEL_PICKER_MIN_MODELS,
        ScopeCandidate,
        resolveScopeUpdate,
        scopeCandidates,
        shouldOfferModelPicker,
    }
    client.src.lib.routing --> "client/src/lib/model-scope-selection.test" { FallbackEntry }
    "client/src/lib/model-settings" --> "client/src/lib/model-settings.test" {
        ModelSettingsSource,
        modelSettingsForm,
        parseOptionalCount,
        parseRank,
        reviewModelSettings,
    }
    "client/src/lib/new-build" --> "client/src/lib/new-build.test" { entryScriptSrc, isNewBuild }
    "client/src/lib/playground-conversations" --> "client/src/lib/playground-conversations.test" {
        ACTIVE_CONVERSATION_KEY,
        AUTO_TITLE_MAX,
        ChatMessage,
        autoTitle,
        readActiveConversationId,
        relativeTime,
        toStoredMessages,
        writeActiveConversationId,
    }
    client.src.lib.api --> "client/src/lib/playground-conversations" { apiFetch }
    "client/src/lib/playground-sampling" --> "client/src/lib/playground-sampling.test" {
        DEFAULT_SAMPLING,
        SamplingSettings,
        clampSampling,
        formatSamplingValue,
        normalizeSampling,
        parseSampling,
        samplingActiveCount,
        samplingRequestParams,
        serializeSampling,
        setSamplingEnabled,
        setSamplingValue,
    }
    "client/src/lib/playground-stream" --> "client/src/lib/playground-stream.test" {
        ChatStreamHandlers,
        frameData,
        readChatStream,
    }
    client.src.lib.routing --> "client/src/lib/routing.test" {
        RateLimitUsageRow,
        Row,
        buildGroups,
        clampRankToIndex,
        groupMatchesQuery,
        isGroupDepleted,
        isMemberDepleted,
        isMemberSplit,
        memberEndpointTitle,
        memberOverrideKey,
        memberProviderLabel,
        providerPinId,
        splitsWithoutMember,
        tightestRateLimit,
    }
    client.src.lib.search --> "client/src/lib/search.test" {
        SearchEngine,
        SearchReadiness,
        engineChain,
        freeFromDate,
        hostOf,
        isSearchPlatform,
        searchContextMessage,
        searchProviderName,
        searchReadinessHint,
    }
    "client/src/lib/toast-timer" --> "client/src/lib/toast-timer.test" { startToastTimer }
    client.src.lib.toast --> "client/src/lib/toast.test";
    client.src.lib.transcription --> "client/src/lib/transcription.test" {
        TranscriptionModelRow,
        appendDictation,
        availableTranscriptionModels,
        hasTranscription,
        pickRecordingMimeType,
        recordingFilename,
        resolveDictationModel,
        transcriptionOptions,
    }
    client.src.lib.waveform --> "client/src/lib/waveform.test" { WAVE_BAR_COUNT, barHeights }
    client.src.i18n.index --> "client/src/pages/FallbackPage.toggle-persistence.test" {
        I18nProvider,
    }
    client.src.pages.FallbackPage --> "client/src/pages/FallbackPage.toggle-persistence.test" {
        default,
    }
    client.src.lib.routing --> "client/src/pages/FallbackPage.toggle-persistence.test" {
        FallbackEntry,
    }
    client.src.i18n.index --> client.src.pages.FallbackPage { useI18n }
    client.src.lib.api --> client.src.pages.FallbackPage { apiFetch }
    client.src.lib.toast --> client.src.pages.FallbackPage { toast }
    client.src.lib.routing --> client.src.pages.FallbackPage {
        FallbackEntry,
        KeySelectionStrategy,
        ModelGroupRow,
        RateLimitUsageData,
        RoutingData,
        RoutingStrategy,
        RoutingWeights,
        Row,
        TokenUsageData,
        buildGroups,
        clampRankToIndex,
        groupMatchesQuery,
        groupMaxContext,
        isGroupDepleted,
    }
    client.src.components.ui.button --> client.src.pages.FallbackPage { Button }
    "client/src/components/custom-weights-popover" --> client.src.pages.FallbackPage {
        CustomWeightsPopover,
    }
    "client/src/components/empty-state" --> client.src.pages.FallbackPage { EmptyState }
    "client/src/components/getting-started" --> client.src.pages.FallbackPage { GettingStarted }
    "client/src/components/model-table" --> client.src.pages.FallbackPage {
        GroupHeaderCells,
        ModelTableHead,
        SortableGroupRow,
    }
    client.src.components.ui.skeleton --> client.src.pages.FallbackPage { TableSkeleton }
    "client/src/components/token-usage-bar" --> client.src.pages.FallbackPage { TokenUsageBar }
    "client/src/components/page-header" --> client.src.pages.FallbackPage { PageHeader }
    "client/src/components/floating-bar" --> client.src.pages.FallbackPage { FloatingBar }
    "client/src/components/models-tabs" --> client.src.pages.FallbackPage { ModelsTabs }
    client.src.components.tooltip --> client.src.pages.FallbackPage { Tooltip }
    "client/src/components/penalty-inspector" --> client.src.pages.FallbackPage { PenaltyInspector }
    "client/src/components/peak-hours-controls" --> client.src.pages.FallbackPage {
        PeakHoursControls,
    }
    "client/src/components/reliability-floor-control" --> client.src.pages.FallbackPage {
        ReliabilityFloorControl,
    }
    "client/src/components/provider-moment-control" --> client.src.pages.FallbackPage {
        ProviderMomentControl,
    }
    "client/src/components/decision-routing-popover" --> client.src.pages.FallbackPage {
        DecisionRoutingPopover,
        DecisionSetupGuide,
    }
    "client/src/components/chain-manager" --> client.src.pages.FallbackPage { ChainManager }
    client.src.i18n.index --> "client/src/components/custom-weights-popover" { useI18n }
    client.src.components.ui.button --> "client/src/components/custom-weights-popover" { Button }
    client.src.components.ui.popover --> "client/src/components/custom-weights-popover" {
        Popover,
        PopoverContent,
        PopoverTrigger,
    }
    client.src.lib.routing --> "client/src/components/custom-weights-popover" { RoutingWeights }
    client.src.i18n.index --> "client/src/components/token-usage-bar" { useI18n }
    "client/src/lib/budget-legend" --> "client/src/components/token-usage-bar" { buildBudgetLegend }
    client.src.lib.routing --> "client/src/components/token-usage-bar" {
        TokenUsageData,
        formatPercent,
        formatTokens,
        platformColors,
    }
    client.src.i18n.index --> "client/src/components/penalty-inspector" { useI18n }
    client.src.lib.api --> "client/src/components/penalty-inspector" { apiFetch }
    client.src.i18n.index --> "client/src/components/peak-hours-controls" { useI18n }
    client.src.components.tooltip --> "client/src/components/peak-hours-controls" { Tooltip }
    client.src.lib.routing --> "client/src/components/peak-hours-controls" {
        PEAK_EXEMPT_STRATEGIES,
        RoutingData,
        RoutingStrategy,
    }
    client.src.i18n.index --> "client/src/components/reliability-floor-control" { useI18n }
    client.src.lib.api --> "client/src/components/reliability-floor-control" { apiFetch }
    client.src.components.tooltip --> "client/src/components/reliability-floor-control" { Tooltip }
    client.src.i18n.index --> "client/src/components/provider-moment-control" { useI18n }
    client.src.lib.api --> "client/src/components/provider-moment-control" { apiFetch }
    client.src.components.tooltip --> "client/src/components/provider-moment-control" { Tooltip }
    client.src.i18n.index --> "client/src/components/chain-manager" { useI18n }
    client.src.lib.api --> "client/src/components/chain-manager" { ApiError, apiFetch }
    client.src.components.ui.button --> "client/src/components/chain-manager" { Button }
    client.src.components.ui.input --> "client/src/components/chain-manager" { Input }
    client.src.components.ui.badge --> "client/src/components/chain-manager" { Badge }
    client.src.components.tooltip --> "client/src/components/chain-manager" { Tooltip }
    client.src.i18n.index --> "client/src/pages/KeysPage.add-link.test" { I18nProvider }
    client.src.pages.KeysPage --> "client/src/pages/KeysPage.add-link.test" { default }
    client.src.i18n.index --> "client/src/pages/PlaygroundPage.dictation.test" { I18nProvider }
    client.src.lib.toast --> "client/src/pages/PlaygroundPage.dictation.test" { toast }
    client.src.lib.transcription --> "client/src/pages/PlaygroundPage.dictation.test" {
        TranscriptionModelRow,
    }
    client.src.pages.PlaygroundPage --> "client/src/pages/PlaygroundPage.dictation.test" { default }
    client.src.lib.api --> client.src.pages.PlaygroundPage { apiFetch }
    "client/src/lib/model-groups" --> client.src.pages.PlaygroundPage { buildModelOptions }
    "client/src/components/chain-manager" --> client.src.pages.PlaygroundPage { Chain }
    client.src.components.markdown --> client.src.pages.PlaygroundPage { Markdown }
    "client/src/lib/artifact-host" --> client.src.pages.PlaygroundPage { ArtifactHostContext }
    "client/src/components/playground/artifact-panel" --> client.src.pages.PlaygroundPage {
        ARTIFACT_PANEL_TRANSITION_MS,
        ArtifactPanel,
    }
    "client/src/lib/artifact-panel-size" --> client.src.pages.PlaygroundPage {
        ARTIFACT_WIDTH_STORAGE_KEY,
        clampArtifactWidth,
        readArtifactWidth,
    }
    client.src.lib.artifacts --> client.src.pages.PlaygroundPage {
        Artifact,
        ArtifactKind,
        extractArtifacts,
    }
    "client/src/components/copy-button" --> client.src.pages.PlaygroundPage { CopyButton }
    client.src.lib.toast --> client.src.pages.PlaygroundPage { toast }
    client.src.lib.attachments --> client.src.pages.PlaygroundPage {
        ACCEPT_ATTRIBUTE,
        Attachment,
        AttachmentError,
        MAX_ATTACHMENTS,
        MAX_IMAGE_BYTES,
        MAX_TEXT_BYTES,
        MAX_TOTAL_IMAGE_BYTES,
        attachmentImages,
        classifyFile,
        composeText,
        dataUrlBytes,
        formatBytes,
        readImageAttachment,
        readTextAttachment,
        toMessageContent,
    }
    "client/src/lib/playground-stream" --> client.src.pages.PlaygroundPage { readChatStream }
    "client/src/components/playground/conversation-sidebar" --> client.src.pages.PlaygroundPage {
        ConversationSidebar,
    }
    "client/src/components/playground/settings-rail" --> client.src.pages.PlaygroundPage {
        SettingsRail,
    }
    "client/src/components/playground/liquid-composer" --> client.src.pages.PlaygroundPage {
        LiquidComposer,
    }
    "client/src/components/playground/search-sources" --> client.src.pages.PlaygroundPage {
        SearchSources,
    }
    client.src.lib.search --> client.src.pages.PlaygroundPage {
        SearchResult,
        searchContextMessage,
        searchProviderName,
        searchReadinessHint,
    }
    "client/src/hooks/use-search-readiness" --> client.src.pages.PlaygroundPage {
        useSearchReadiness,
    }
    "client/src/components/model-maker-icon" --> client.src.pages.PlaygroundPage { ModelMakerIcon }
    "client/src/lib/composer-geometry" --> client.src.pages.PlaygroundPage { composerHasContent }
    client.src.lib.transcription --> client.src.pages.PlaygroundPage {
        DICTATION_AUTO,
        DICTATION_MODEL_STORAGE_KEY,
        TranscriptionModelRow,
        appendDictation,
        hasTranscription,
        resolveDictationModel,
        transcriptionOptions,
    }
    "client/src/lib/playground-sampling" --> client.src.pages.PlaygroundPage {
        SamplingSettings,
        readSampling,
        samplingRequestParams,
        writeSampling,
    }
    "client/src/lib/playground-conversations" --> client.src.pages.PlaygroundPage {
        ChatMessage,
        ConversationSummary,
        FusionPanelEntry,
        SIDEBAR_OPEN_KEY,
        WebSearchMeta,
        autoTitle,
        createConversation,
        deleteConversation,
        getConversation,
        listConversations,
        readActiveConversationId,
        toStoredMessages,
        updateConversation,
        writeActiveConversationId,
    }
    client.src.i18n.index --> client.src.pages.PlaygroundPage { useI18n }
    client.src.lib.utils --> client.src.components.markdown { cn }
    "client/src/components/copy-button" --> client.src.components.markdown { CopyButton }
    "client/src/components/code-block" --> client.src.components.markdown { CodeBlock }
    client.src.lib.artifacts --> client.src.components.markdown { ArtifactKind, artifactKindOf }
    "client/src/lib/artifact-host" --> client.src.components.markdown { ArtifactHostContext }
    client.src.i18n.index --> client.src.components.markdown { useI18n }
    client.src.lib.artifacts --> "client/src/lib/artifact-host" { ArtifactKind }
    client.src.components.ui.button --> "client/src/components/playground/artifact-panel" { Button }
    "client/src/components/copy-button" --> "client/src/components/playground/artifact-panel" {
        CopyButton,
    }
    "client/src/components/code-block" --> "client/src/components/playground/artifact-panel" {
        CodeBlock,
    }
    client.src.i18n.index --> "client/src/components/playground/artifact-panel" { useI18n }
    client.src.lib.artifacts --> "client/src/components/playground/artifact-panel" {
        ARTIFACT_SANDBOX,
        Artifact,
        artifactMimeType,
        artifactSrcDoc,
    }
    "client/src/lib/artifact-panel-size" --> "client/src/components/playground/artifact-panel" {
        ARTIFACT_KEY_STEP,
        clampArtifactWidth,
        draggedArtifactWidth,
    }
    client.src.components.ui.button --> "client/src/components/playground/conversation-sidebar" {
        Button,
        buttonVariants,
    }
    "client/src/components/ui/dropdown-menu" --> "client/src/components/playground/conversation-sidebar" {
        DropdownMenu,
        DropdownMenuContent,
        DropdownMenuItem,
        DropdownMenuTrigger,
    }
    "client/src/lib/playground-conversations" --> "client/src/components/playground/conversation-sidebar" {
        ConversationSummary,
    }
    client.src.i18n.index --> "client/src/components/playground/conversation-sidebar" { useI18n }
    client.src.components.ui.button --> "client/src/components/playground/settings-rail" { Button }
    client.src.components.ui.switch --> "client/src/components/playground/settings-rail" { Switch }
    "client/src/components/model-combobox" --> "client/src/components/playground/settings-rail" {
        ModelComboOption,
        ModelCombobox,
    }
    "client/src/lib/playground-sampling" --> "client/src/components/playground/settings-rail" {
        SAMPLING_FIELDS,
        SAMPLING_RANGES,
        SamplingField,
        SamplingSettings,
        formatSamplingValue,
        samplingActiveCount,
        setSamplingEnabled,
        setSamplingValue,
    }
    client.src.i18n.index --> "client/src/components/playground/settings-rail" { useI18n }
    client.src.i18n.index --> "client/src/components/playground/search-sources" { useI18n }
    client.src.lib.search --> "client/src/components/playground/search-sources" { hostOf }
    "client/src/lib/playground-conversations" --> "client/src/components/playground/search-sources" {
        WebSearchMeta,
    }
    "client/src/lib/model-maker" --> "client/src/components/model-maker-icon" {
        ModelMakerId,
        modelMakerOf,
    }
    server.src.db.index --> "server/src/__tests__/db/factory-injection.test" { connectDb }
    server.src.db.types --> "server/src/__tests__/db/factory-injection.test" { Db, DbFactory }
    server.src.db.migrate.runner --> server.src.db.index { runMigrationsSync }
    server.src.lib.crypto --> server.src.db.index {
        initEncryptionKey,
        isEncryptionKeyInitialized,
        probeStoredSecrets,
    }
    "server/src/lib/file-permissions" --> server.src.db.index {
        restrictAllToOwner,
        restrictDirToOwner,
    }
    "server/src/db/node-sqlite" --> server.src.db.index { nodeSqliteFactory }
    server.src.db.types --> server.src.db.index { Db, DbFactory }
    server.src.db.types --> server.src.db.migrate.runner { Db }
    server.src.db.migrate.defaults --> server.src.db.migrate.runner {
        DEFAULT_MIGRATIONS,
        MigrationModule,
    }
    server.src.db.types --> server.src.db.migrate.defaults { Db }
    "server/src/db/migrations/20260101_000000_legacy_baseline" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260627_000001_custom_provider_modalities" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260627_000002_catalog_model_state" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260628_120000_request_aggregates" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260630_000001_github_gpt41_context" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260706_000001_request_client_info" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260706_000002_custom_model_tool_support" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260714_000001_profile_chain_backfill" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260720_000001_key_health_error" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260726_000001_cooldown_probe_provenance" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260726_000002_request_attempts" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260726_000003_model_source_provenance" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260726_000004_media_model_meta" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260726_000005_request_served_model" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260726_000006_attempt_error_summary" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260727_000001_agent_compatibility" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260728_000001_tombstone_provenance" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260729_000001_custom_model_endpoint_identity" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260802_000001_custom_endpoint_host_labels" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260805_000001_key_model_scope" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260805_000002_client_profiles" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260810_000001_api_key_proxy" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260820_000001_playground_conversations" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260819_000001_custom_model_tombstones" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260823_000001_server_logs" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260823_000002_backups_table" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260823_000003_attempt_key_label" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260823_000004_profile_auto_include" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260901_000001_idempotency_claims" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260901_000003_request_caller" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260901_000002_quota_observation_lookup" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260902_000001_analytics_latency_percentile_index" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260903_000001_mcp_enabled_default" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260903_000002_response_cache" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260904_000001_key_monthly_budget" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260914_000001_key_monthly_usage" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260915_000001_quota_snapshot_freshness" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260913_000001_request_model_attribution" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20260930_000001_custom_endpoint_group_label" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261007_000001_model_probe_status" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261013_000001_search_engines" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261016_000001_decision_requests" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261017_000001_llmtr_reenable_keys" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261017_000002_remove_github_provider" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261017_233153_request_failure_attribution" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261019_000001_remove_auray_provider" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261020_000001_key_last_healthy_at" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261028_000001_custom_media_endpoint_identity" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261104_000001_cloudflare_neuron_usage" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261105_000001_key_verification_basis" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261111_000001_model_monthly_usage" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261111_000002_profile_routing_strategy" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261117_000001_embedding_rate_limits" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261117_000002_custom_embedding_input_type" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261118_000001_embedding_source_provenance" --> server.src.db.migrate.defaults;
    "server/src/db/migrations/20261124_000001_oidc_identities" --> server.src.db.migrate.defaults;
    server.src.db.types --> "server/src/db/migrations/20260101_000000_legacy_baseline" { Db }
    server.src.lib.crypto --> "server/src/db/migrations/20260101_000000_legacy_baseline" {
        initEncryptionKey,
    }
    "server/src/db/model-pricing" --> "server/src/db/migrations/20260101_000000_legacy_baseline" {
        applyModelPricing,
    }
    "server/src/lib/file-permissions" --> server.src.lib.crypto { restrictToOwner }
    server.src.db.types --> server.src.lib.crypto { Db }
    server.src.db.types --> "server/src/db/model-pricing" { Db }
    server.src.db.types --> "server/src/db/migrations/20260627_000001_custom_provider_modalities" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260627_000002_catalog_model_state" { Db }
    server.src.db.types --> "server/src/db/migrations/20260628_120000_request_aggregates" { Db }
    server.src.db.types --> "server/src/db/migrations/20260630_000001_github_gpt41_context" { Db }
    server.src.db.types --> "server/src/db/migrations/20260706_000001_request_client_info" { Db }
    server.src.db.types --> "server/src/db/migrations/20260706_000002_custom_model_tool_support" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260714_000001_profile_chain_backfill" { Db }
    server.src.db.types --> "server/src/db/migrations/20260720_000001_key_health_error" { Db }
    server.src.db.types --> "server/src/db/migrations/20260726_000001_cooldown_probe_provenance" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260726_000002_request_attempts" { Db }
    server.src.db.types --> "server/src/db/migrations/20260726_000003_model_source_provenance" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260726_000004_media_model_meta" { Db }
    server.src.db.types --> "server/src/db/migrations/20260726_000005_request_served_model" { Db }
    server.src.db.types --> "server/src/db/migrations/20260726_000006_attempt_error_summary" { Db }
    server.src.db.types --> "server/src/db/migrations/20260727_000001_agent_compatibility" { Db }
    server.src.db.types --> "server/src/db/migrations/20260728_000001_tombstone_provenance" { Db }
    server.src.db.types --> "server/src/db/migrations/20260729_000001_custom_model_endpoint_identity" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260802_000001_custom_endpoint_host_labels" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260805_000001_key_model_scope" { Db }
    server.src.db.types --> "server/src/db/migrations/20260805_000002_client_profiles" { Db }
    server.src.db.types --> "server/src/db/migrations/20260810_000001_api_key_proxy" { Db }
    server.src.db.types --> "server/src/db/migrations/20260820_000001_playground_conversations" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260819_000001_custom_model_tombstones" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260823_000001_server_logs" { Db }
    server.src.db.types --> "server/src/db/migrations/20260823_000002_backups_table" { Db }
    server.src.db.types --> "server/src/db/migrations/20260823_000003_attempt_key_label" { Db }
    server.src.db.types --> "server/src/db/migrations/20260823_000004_profile_auto_include" { Db }
    server.src.db.types --> "server/src/db/migrations/20260901_000001_idempotency_claims" { Db }
    server.src.db.types --> "server/src/db/migrations/20260901_000003_request_caller" { Db }
    server.src.db.types --> "server/src/db/migrations/20260901_000002_quota_observation_lookup" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260902_000001_analytics_latency_percentile_index" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260903_000001_mcp_enabled_default" { Db }
    server.src.db.types --> "server/src/db/migrations/20260903_000002_response_cache" { Db }
    server.src.db.types --> "server/src/db/migrations/20260904_000001_key_monthly_budget" { Db }
    server.src.db.types --> "server/src/db/migrations/20260914_000001_key_monthly_usage" { Db }
    server.src.db.types --> "server/src/db/migrations/20260915_000001_quota_snapshot_freshness" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260913_000001_request_model_attribution" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20260930_000001_custom_endpoint_group_label" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20261007_000001_model_probe_status" { Db }
    server.src.db.types --> "server/src/db/migrations/20261013_000001_search_engines" { Db }
    server.src.db.types --> "server/src/db/migrations/20261016_000001_decision_requests" { Db }
    server.src.db.types --> "server/src/db/migrations/20261017_000001_llmtr_reenable_keys" { Db }
    server.src.db.types --> "server/src/db/migrations/20261017_000002_remove_github_provider" { Db }
    server.src.db.types --> "server/src/db/migrations/20261017_233153_request_failure_attribution" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20261019_000001_remove_auray_provider" { Db }
    server.src.db.types --> "server/src/db/migrations/20261020_000001_key_last_healthy_at" { Db }
    server.src.db.types --> "server/src/db/migrations/20261028_000001_custom_media_endpoint_identity" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20261104_000001_cloudflare_neuron_usage" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20261105_000001_key_verification_basis" { Db }
    server.src.db.types --> "server/src/db/migrations/20261111_000001_model_monthly_usage" { Db }
    server.src.db.types --> "server/src/db/migrations/20261111_000002_profile_routing_strategy" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20261117_000001_embedding_rate_limits" { Db }
    server.src.db.types --> "server/src/db/migrations/20261117_000002_custom_embedding_input_type" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20261118_000001_embedding_source_provenance" {
        Db,
    }
    server.src.db.types --> "server/src/db/migrations/20261124_000001_oidc_identities" { Db }
    server.src.db.types --> "server/src/db/node-sqlite" { Db, DbFactory, DbStatement }
    server.src.db.index --> "server/src/__tests__/db/hardening.test" {
        connectDb,
        getDefaultDbPath,
        shouldHardenDataDir,
    }
    server.src.__tests__.helpers.acl --> "server/src/__tests__/db/hardening.test" { aclEntries }
    server.src.db.index --> "server/src/__tests__/db/idempotency.test" { initDb }
    server.src.providers.index --> "server/src/__tests__/db/idempotency.test";
    server.src.providers.base --> server.src.providers.index { BaseProvider }
    server.src.providers.google --> server.src.providers.index { GoogleProvider }
    "server/src/providers/openai-compat" --> server.src.providers.index { OpenAICompatProvider }
    server.src.providers.cohere --> server.src.providers.index { CohereProvider }
    server.src.providers.tavily --> server.src.providers.index { TavilyProvider }
    server.src.providers.exa --> server.src.providers.index { ExaProvider }
    server.src.providers.firecrawl --> server.src.providers.index { FirecrawlProvider }
    server.src.providers.linkup --> server.src.providers.index { LinkupProvider }
    server.src.providers.parallel --> server.src.providers.index { ParallelProvider }
    server.src.providers.keenable --> server.src.providers.index { KeenableProvider }
    server.src.providers.outcrawl --> server.src.providers.index { OutcrawlProvider }
    server.src.providers.tinyfish --> server.src.providers.index { TinyFishProvider }
    server.src.providers.llmkiwi --> server.src.providers.index { LlmKiwiProvider }
    "server/src/providers/decision-only" --> server.src.providers.index { KeylessDecisionProvider }
    server.src.providers.cloudflare --> server.src.providers.index { CloudflareProvider }
    server.src.providers.aihorde --> server.src.providers.index { AIHordeProvider }
    server.src.providers.modelscope --> server.src.providers.index { ModelScopeProvider }
    server.src.providers.pollinations --> server.src.providers.index { PollinationsProvider }
    server.src.providers.zhipu --> server.src.providers.index { ZhipuProvider }
    server.src.providers.puter --> server.src.providers.index { PuterProvider }
    server.src.providers.sail --> server.src.providers.index { SailProvider }
    server.src.providers.aclide --> server.src.providers.index { AclideProvider }
    server.src.providers.speka --> server.src.providers.index { SpekaProvider }
    server.src.providers.kenari --> server.src.providers.index { KenariProvider }
    server.src.providers.kiosapi --> server.src.providers.index { KiosAPIProvider }
    server.src.providers.typhoon --> server.src.providers.index { TyphoonProvider }
    server.src.providers.plugsky --> server.src.providers.index { PlugskyProvider }
    server.src.providers.inferbase --> server.src.providers.index { InferbaseProvider }
    server.src.providers.simplellm --> server.src.providers.index { SimpleLLMProvider }
    server.src.providers.llmtr --> server.src.providers.index { LlmtrProvider }
    server.src.providers.gizmo --> server.src.providers.index { GizmoProvider }
    server.src.providers.blockrun --> server.src.providers.index { BlockRunProvider }
    server.src.providers.moondream --> server.src.providers.index { MoondreamProvider }
    server.src.providers.jamai --> server.src.providers.index { JamaiProvider }
    server.src.providers.nabh --> server.src.providers.index { NabhProvider }
    server.src.providers.zro --> server.src.providers.index { ZroProvider }
    server.src.providers.novai --> server.src.providers.index { NovaiProvider }
    server.src.providers.freeinference --> server.src.providers.index { FreeInferenceProvider }
    server.src.providers.freemodel --> server.src.providers.index { FreeModelProvider }
    server.src.providers.electronhub --> server.src.providers.index { ElectronHubProvider }
    server.src.providers.experiential --> server.src.providers.index { ExperientialProvider }
    server.src.providers.router9 --> server.src.providers.index { Router9Provider }
    server.src.providers.septor --> server.src.providers.index { SeptorProvider }
    server.src.providers.clod --> server.src.providers.index { ClodProvider }
    server.src.providers.speechify --> server.src.providers.index { SpeechifyProvider }
    server.src.providers.varosity --> server.src.providers.index { VarosityProvider }
    server.src.providers.speechflow --> server.src.providers.index { SpeechFlowProvider }
    server.src.providers.meldport --> server.src.providers.index { MeldportProvider }
    server.src.providers.rime --> server.src.providers.index { RimeProvider }
    "server/src/providers/voice-gateways" --> server.src.providers.index {
        CartesiaProvider,
        TypecastProvider,
    }
    server.src.providers.silvr --> server.src.providers.index { SilvrProvider }
    server.src.providers.freetts --> server.src.providers.index { FreeTtsProvider }
    server.src.providers.freeai --> server.src.providers.index { FreeAiProvider }
    server.src.providers.blaze --> server.src.providers.index { BlazeProvider }
    server.src.providers.lucidity --> server.src.providers.index { LucidityProvider }
    server.src.providers.airforce --> server.src.providers.index { AirforceProvider }
    server.src.providers.dreamprompting --> server.src.providers.index { DreamPromptingProvider }
    server.src.providers.waterfall --> server.src.providers.index { WaterfallProvider }
    server.src.providers.logfare --> server.src.providers.index { LogfareProvider }
    server.src.providers.beatapi --> server.src.providers.index { BeatApiProvider }
    server.src.providers.apinex --> server.src.providers.index { ApinexProvider }
    server.src.providers.onomeo --> server.src.providers.index { OnomeoProvider }
    server.src.providers.iteracompute --> server.src.providers.index { IteraComputeProvider }
    server.src.providers.serpsearch --> server.src.providers.index { SerpSearchProvider }
    server.src.providers.brave --> server.src.providers.index { BraveProvider }
    "server/src/services/provider-quota" --> server.src.providers.base { QuotaObservationContext }
    "server/src/lib/sampling-params" --> server.src.providers.base { ExtendedSamplingOptions }
    server.src.lib.proxy --> server.src.providers.base { proxyFetch }
    "server/src/lib/provider-timeout" --> server.src.providers.base {
        providerTimeoutMs,
        streamStallTimeoutMs,
    }
    "server/src/lib/upstream-watch" --> server.src.providers.base { currentUpstreamWatch }
    "server/src/lib/think-tags" --> server.src.providers.base { extractThinkTagsFromStream }
    server.src.db.index --> "server/src/services/provider-quota" { getDb }
    server.src.providers.base --> "server/src/services/provider-quota" { parseRetryAfterMs }
    server.src.db.index --> "server/src/lib/sampling-params" { getSetting }
    server.src.db.index --> server.src.lib.proxy { getSetting }
    server.src.lib.crypto --> server.src.lib.proxy { decrypt, encrypt }
    "server/src/lib/url-guard" --> server.src.lib.proxy {
        assertProviderUrlAllowed,
        isLoopbackOrPrivateHostname,
    }
    server.src.providers.base --> server.src.providers.google {
        BaseProvider,
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    server.src.lib.content --> server.src.providers.google { contentToString }
    server.src.lib.proxy --> server.src.providers.google { proxyFetch }
    "server/src/lib/url-guard" --> server.src.providers.google { assessProviderUrl }
    "server/src/services/provider-quota" --> server.src.providers.google {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    "server/src/lib/provider-timeout" --> server.src.providers.google {
        providerTimeoutMs,
        streamStallTimeoutMs,
    }
    "server/src/lib/upstream-watch" --> server.src.providers.google { currentUpstreamWatch }
    "server/src/lib/gemini-wire" --> server.src.providers.google { sanitizeForGemini }
    "server/src/lib/sampling-params" --> server.src.providers.google { resolveMaxTokens }
    "server/src/lib/sampling-params" --> "server/src/lib/gemini-wire" {
        ReasoningEffort,
        ResponseFormat,
    }
    "server/src/lib/inbound-chat" --> "server/src/lib/gemini-wire" { InboundChatResult }
    server.src.db.index --> "server/src/lib/inbound-chat" { getDb }
    server.src.services.router --> "server/src/lib/inbound-chat" {
        ChainRow,
        RouteResult,
        resolveModelGroupCandidates,
        resolveStickyPreference,
        routeRequest,
        routingReserveTokens,
    }
    "server/src/services/model-groups" --> "server/src/lib/inbound-chat" {
        getModelGroups,
        isUnifyEnabled,
        resolveRequestedIdForDispatch,
    }
    "server/src/lib/fallback-loop" --> "server/src/lib/inbound-chat" {
        AttemptRecord,
        ExhaustionBody,
        REASONING_HOLD_MAX_MS,
        fallbackRoutingTokens,
        newFallbackState,
        recordUpstreamSuccess,
        runFallbackLoop,
        setExhaustionHeaders,
        setFallbackHeaders,
    }
    "server/src/lib/header-value" --> "server/src/lib/inbound-chat" { routedViaValue }
    server.src.lib.guardrails --> "server/src/lib/inbound-chat" {
        applyTokenBudget,
        tokenBudgetMessage,
    }
    server.src.lib.content --> "server/src/lib/inbound-chat" {
        contentToString,
        estimateInputTokens,
    }
    "server/src/lib/output-cap" --> "server/src/lib/inbound-chat" { routeOutputBudget }
    "server/src/lib/image-normalize" --> "server/src/lib/inbound-chat" { normalizeMessageImages }
    "server/src/lib/tool-args" --> "server/src/lib/inbound-chat" {
        repairToolArguments,
        toolSchemaMap,
    }
    "server/src/lib/tool-validate" --> "server/src/lib/inbound-chat" {
        invalidToolArgumentsError,
        invalidToolCallReasons,
        isToolArgumentValidationEnabled,
    }
    "server/src/lib/tool-call-rescue" --> "server/src/lib/inbound-chat" {
        containsDialectMarker,
        couldBecomeDialectMarker,
        rescueInlineToolCalls,
        startsWithDialectMarker,
    }
    "server/src/lib/error-redaction" --> "server/src/lib/inbound-chat" {
        sanitizeProviderErrorMessage,
    }
    "server/src/lib/error-classify" --> "server/src/lib/inbound-chat" {
        isUpstreamClassificationOutput,
        newClientAbortError,
    }
    "server/src/lib/request-log" --> "server/src/lib/inbound-chat" { logRequest }
    server.src.routes.proxy --> "server/src/lib/inbound-chat" { getStickyModel, setStickyModel }
    server.src.providers.base --> "server/src/lib/inbound-chat" { CompletionOptions }
    server.src.db.index --> server.src.services.router { getDb, getSetting, setSetting }
    server.src.providers.index --> server.src.services.router {
        getProvider,
        hasProvider,
        resolveProvider,
    }
    server.src.lib.crypto --> server.src.services.router { decrypt }
    "server/src/lib/key-proxy" --> server.src.services.router { decryptProxyUrl }
    server.src.services.ratelimit --> server.src.services.router {
        acquireLease,
        canMakeRequest,
        canUseKeyConcurrency,
        canUseProvider,
        canUseProviderMinute,
        canUseProviderTokens,
        canUseTokens,
        getCooldownSource,
        getSoonestCooldownExpiry,
        isOnCooldown,
        modelWindowUsedFraction,
        releaseLease,
    }
    server.src.services.scoring --> server.src.services.router {
        BANDIT_PRESETS,
        DEFAULT_PEAK_HOURS,
        DEFAULT_STRATEGY,
        HeadroomThresholds,
        KeySelectionStrategy,
        PeakHoursConfig,
        PresetStrategy,
        RoutingStrategy,
        RoutingWeights,
        TASK_WEIGHT_SHARE,
        TIMEOUT_LATENCY_CAP_MS,
        combineScore,
        expectedReliability,
        headroomFactor,
        intelligenceComposite,
        intelligenceScore,
        isValidPeakHour,
        isValidTimezone,
        observedSpeedRank,
        peakAdjustedWeights,
        rateLimitFactor,
        rateWindowHeadroomFactor,
        reliabilityPosterior,
        sampleBeta,
        speedScore,
        taskAdjustedWeights,
    }
    "server/src/lib/error-classify" --> server.src.services.router {
        TIMEOUT_ERROR_MARKERS,
        isProviderMomentFailure,
    }
    "server/src/services/key-budget" --> server.src.services.router {
        checkMonthlyBudget,
        reserveMonthlyBudget,
    }
    "server/src/services/cloudflare-neurons" --> server.src.services.router {
        cloudflareNeuronsAvailable,
    }
    "server/src/services/model-weight-overrides" --> server.src.services.router {
        applyModelWeightOverride,
        getModelWeightOverrides,
    }
    "server/src/services/model-state" --> server.src.services.router {
        getCatalogModelTombstone,
        modelsWithOverriddenField,
    }
    server.src.lib.budget --> server.src.services.router { parseBudget }
    "server/src/lib/sampling-params" --> server.src.services.router { platformDropsResponseFormat }
    "server/src/lib/min-context-window" --> server.src.services.router { passesContextWindowFloor }
    "server/src/services/model-groups" --> server.src.services.router {
        getModelGroups,
        isUnifyEnabled,
        resolveRequestedIdForDispatch,
    }
    "server/src/services/profile-models" --> server.src.services.router { getActiveProfileId }
    "server/src/lib/client-context" --> server.src.services.router { getClientContext }
    "server/src/services/custom-endpoint" --> server.src.services.router { customEndpointKeyIds }
    server.src.services.degradation --> server.src.services.router { isDegraded }
    "server/src/lib/endpoint-scope" --> server.src.services.router {
        endpointScopeForBaseUrl,
        modelStatsKey,
    }
    "server/src/lib/tool-capability" --> server.src.services.router { isToolBenched }
    "server/src/lib/model-scope" --> server.src.services.router { parseModelScope, scopeAllows }
    "server/src/services/provider-quota" --> server.src.services.router {
        getKeyQuotaHeadroom,
        inferQuotaPoolKey,
    }
    server.src.providers.base --> server.src.services.router { BaseProvider }
    server.src.db.types --> server.src.services.router { Db }
    server.src.lib.crypto --> "server/src/lib/key-proxy" { decrypt, encrypt }
    server.src.lib.proxy --> "server/src/lib/key-proxy" { PROXY_SCHEMES }
    server.src.db.index --> server.src.services.ratelimit { getDb, getSetting, setSetting }
    "server/src/lib/url-guard" --> server.src.services.ratelimit { isLoopbackOrPrivateUrl }
    "server/src/lib/model-scope" --> server.src.services.ratelimit { parseModelScope, scopeAllows }
    "server/src/lib/provider-timeout" --> server.src.services.ratelimit { providerTimeoutMs }
    server.src.db.index --> "server/src/services/key-budget" { getDb }
    server.src.db.index --> "server/src/services/cloudflare-neurons" { getDb }
    "server/src/services/cloudflare-daily-quota" --> "server/src/services/cloudflare-neurons" {
        benchCloudflareAccountId,
        cloudflareAccountId,
    }
    server.src.db.index --> "server/src/services/cloudflare-daily-quota" { getDb }
    server.src.lib.crypto --> "server/src/services/cloudflare-daily-quota" { decrypt }
    server.src.services.ratelimit --> "server/src/services/cloudflare-daily-quota" {
        CooldownSource,
        setCooldown,
    }
    server.src.db.index --> "server/src/services/model-weight-overrides" { getDb, getSetting }
    server.src.db.types --> "server/src/services/model-state" { Db }
    "server/src/services/catalog-sync" --> "server/src/services/model-state" { applyCatalog }
    "server/src/services/specialist-text" --> "server/src/services/catalog-sync" {
        SpecialistRow,
        specialistTask,
    }
    server.src.db.types --> "server/src/services/catalog-sync" { Db }
    server.src.db.index --> "server/src/services/catalog-sync" { getDb, getSetting, setSetting }
    server.src.providers.index --> "server/src/services/catalog-sync" { hasProvider }
    server.src.services.media --> "server/src/services/catalog-sync" {
        MEDIA_PLATFORMS,
        TRANSCRIPTION_PLATFORMS,
        VIDEO_PLATFORMS,
    }
    server.src.services.search --> "server/src/services/catalog-sync" {
        SEARCH_ENGINE_PLATFORMS,
        SEARCH_MODALITY,
    }
    server.src.services.decision --> "server/src/services/catalog-sync" {
        CATALOG_DECISION_PLATFORMS,
        DECISION_MODALITY,
    }
    server.src.services.embeddings --> "server/src/services/catalog-sync" { EMBEDDING_PLATFORMS }
    server.src.lib.scheduler --> "server/src/services/catalog-sync" { Scheduler }
    "server/src/services/model-state" --> "server/src/services/catalog-sync" {
        applyAllModelOverrides,
        applyModelOverrides,
        deleteTombstonedCatalogModels,
        isCatalogModelTombstoned,
        refreshModelOverrideBaselines,
        reinstateUpstreamRetiredCatalogModel,
    }
    "server/src/services/profile-models" --> "server/src/services/catalog-sync" {
        ensureAllModelsInProfiles,
    }
    "server/src/services/keyless-defaults" --> "server/src/services/catalog-sync" {
        applyKeylessDefaults,
    }
    server.src.db.index --> "server/src/services/specialist-text" { getDb }
    "server/src/services/provider-credential" --> "server/src/services/specialist-text" {
        reserveProviderCredential,
    }
    "server/src/services/cloudflare-neurons" --> "server/src/services/specialist-text" {
        meterCloudflare,
        roughTokens,
    }
    server.src.lib.proxy --> "server/src/services/specialist-text" { proxyFetch }
    server.src.db.index --> "server/src/services/provider-credential" { getDb }
    server.src.lib.crypto --> "server/src/services/provider-credential" { decrypt }
    "server/src/services/key-budget" --> "server/src/services/provider-credential" {
        reserveMonthlyBudget,
    }
    "server/src/services/cloudflare-neurons" --> "server/src/services/provider-credential" {
        cloudflareNeuronsAvailable,
    }
    "server/src/lib/model-scope" --> "server/src/services/provider-credential" {
        parseModelScope,
        scopeAllows,
    }
    server.src.services.ratelimit --> "server/src/services/provider-credential" {
        canUseProviderMinute,
        getActiveCooldownsForKeys,
        isOnCooldown,
    }
    "server/src/lib/retry-hint" --> "server/src/services/provider-credential" { RetryHintTracker }
    server.src.db.index --> server.src.services.media { getDb }
    server.src.providers.base --> server.src.services.media { parseRetryAfterMs }
    "server/src/lib/retry-hint" --> server.src.services.media { RetryHintTracker }
    "server/src/services/key-budget" --> server.src.services.media { secondsUntilNextMonth }
    "server/src/services/budget-alerts" --> server.src.services.media { noteBudgetAlerts }
    "server/src/lib/client-context" --> server.src.services.media { getClientContext }
    "server/src/services/provider-credential" --> server.src.services.media {
        reserveProviderCredential,
    }
    server.src.providers.speechflow --> server.src.services.media { speechFlowCredentials }
    server.src.lib.proxy --> server.src.services.media { proxyFetch }
    server.src.lib.credential --> server.src.services.media { bearerAuthHeader }
    "server/src/lib/url-guard" --> server.src.services.media { assessProviderUrl }
    server.src.services.ratelimit --> server.src.services.media { isOnCooldown, setCooldown }
    server.src.services.health --> server.src.services.media { markKeyHealthyFromRequest }
    server.src.providers.speechify --> server.src.services.media {
        SPEECHIFY_BASE_URL,
        SPEECHIFY_VERSION,
    }
    server.src.providers.typhoon --> server.src.services.media { TYPHOON_BASE_URL }
    server.src.providers.electronhub --> server.src.services.media { ELECTRONHUB_BASE_URL }
    server.src.providers.silvr --> server.src.services.media { SILVR_BASE_URL }
    server.src.providers.freeai --> server.src.services.media { FREEAI_BASE_URL, freeAiAudioUrl }
    server.src.providers.kenari --> server.src.services.media {
        KENARI_BASE_URL,
        requireKenariFreeModel,
    }
    server.src.providers.plugsky --> server.src.services.media { PLUGSKY_BASE_URL }
    server.src.providers.novai --> server.src.services.media { NOVAI_BASE_URL }
    "server/src/services/media-varosity" --> server.src.services.media {
        VarosityMediaError,
        varosityImage,
        varositySpeech,
        varosityVideo,
    }
    "server/src/services/media-rime" --> server.src.services.media {
        RimeMediaError,
        rimeSpeech,
        rimeTranscription,
    }
    "server/src/services/media-google-live" --> server.src.services.media {
        googleLiveTranscription,
    }
    "server/src/services/media-solaria" --> server.src.services.media { solariaTranscription }
    "server/src/services/media-freetts" --> server.src.services.media {
        FreeTtsMediaError,
        freeTtsSpeech,
    }
    "server/src/services/media-voice-gateways" --> server.src.services.media {
        VoiceGatewayMediaError,
        cartesiaTranscription,
        voiceGatewaySpeech,
    }
    "server/src/lib/image-normalize" --> server.src.services.media { cpuCanRunSharp }
    "server/src/services/cloudflare-neurons" --> server.src.services.media {
        CloudflareNeuronCapError,
        meterCloudflare,
    }
    server.src.db.index --> "server/src/services/budget-alerts" { getDb, getSetting, setSetting }
    "server/src/lib/server-logs" --> "server/src/services/budget-alerts" { providerLog }
    "server/src/services/key-budget" --> "server/src/services/budget-alerts" {
        getMonthlyBudgetCaps,
        getMonthlyUsage,
        nextMonthResetAt,
    }
    server.src.lib.proxy --> "server/src/services/budget-alerts";
    server.src.db.index --> "server/src/lib/server-logs" { getDb }
    "server/src/lib/log-redaction" --> "server/src/lib/server-logs" { redactSecrets }
    server.src.db.types --> "server/src/lib/server-logs" { Db }
    "server/src/lib/server-logs" --> "server/src/lib/log-redaction" {
        recordConsoleLine,
        ServerLogLevel,
    }
    "server/src/lib/client-classifier" --> "server/src/lib/client-context" {
        classifyClientAgent,
        ClientAgent,
    }
    server.src.providers.base --> server.src.providers.speechflow {
        BaseProvider,
        KeyValidationResult,
    }
    server.src.db.index --> server.src.services.health { getDb }
    server.src.providers.index --> server.src.services.health { resolveProvider }
    server.src.providers.base --> server.src.services.health { BaseProvider }
    server.src.lib.crypto --> server.src.services.health { decrypt }
    "server/src/lib/key-proxy" --> server.src.services.health { decryptProxyUrl }
    server.src.lib.proxy --> server.src.services.health { withKeyProxy }
    "server/src/services/provider-quota" --> server.src.services.health { inferQuotaPoolKey }
    server.src.services.degradation --> server.src.services.health { updateDegradationState }
    server.src.lib.scheduler --> server.src.services.health { Scheduler }
    "server/src/lib/error-redaction" --> server.src.services.health { sanitizeProviderErrorMessage }
    "server/src/lib/server-logs" --> server.src.services.health { providerLog }
    "server/src/services/builtin-model-discovery" --> server.src.services.health {
        triggerBuiltinModelDiscovery,
    }
    server.src.db.index --> server.src.services.degradation { getDb }
    "server/src/services/specialist-text" --> "server/src/services/builtin-model-discovery" {
        specialistTask,
    }
    server.src.db.types --> "server/src/services/builtin-model-discovery" { Db }
    server.src.lib.scheduler --> "server/src/services/builtin-model-discovery" { Scheduler }
    server.src.providers.index --> "server/src/services/builtin-model-discovery" { getProvider }
    "server/src/providers/openai-compat" --> "server/src/services/builtin-model-discovery" {
        OpenAICompatProvider,
    }
    server.src.lib.crypto --> "server/src/services/builtin-model-discovery" { decrypt }
    "server/src/lib/key-proxy" --> "server/src/services/builtin-model-discovery" { decryptProxyUrl }
    server.src.lib.proxy --> "server/src/services/builtin-model-discovery" { withKeyProxy }
    "server/src/services/model-discovery" --> "server/src/services/builtin-model-discovery" {
        DiscoveredModel,
        discoverProviderModels,
    }
    "server/src/services/catalog-sync" --> "server/src/services/builtin-model-discovery" {
        DISCOVERED_MODEL_SOURCE,
        appliedCatalogPlatforms,
    }
    "server/src/services/model-state" --> "server/src/services/builtin-model-discovery" {
        clearCatalogModelTombstone,
        isCatalogModelTombstoned,
    }
    "server/src/services/custom-model-seed" --> "server/src/services/builtin-model-discovery" {
        customModelSeed,
    }
    "server/src/services/profile-models" --> "server/src/services/builtin-model-discovery" {
        ensureModelInProfiles,
    }
    "server/src/services/custom-model-sync" --> "server/src/services/builtin-model-discovery" {
        customModelSyncFreePatterns,
        customModelSyncIntervalMs,
    }
    server.src.providers.base --> "server/src/providers/openai-compat" {
        BaseProvider,
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/lib/sampling-params" --> "server/src/providers/openai-compat" {
        extendedBodyParams,
        resolveMaxTokens,
    }
    "server/src/lib/tool-call-rescue" --> "server/src/providers/openai-compat" {
        rescueInlineToolCalls,
    }
    "server/src/lib/think-tags" --> "server/src/providers/openai-compat" { extractThinkFromMessage }
    "server/src/lib/tool-args" --> "server/src/providers/openai-compat" {
        repairToolArguments,
        toolSchemaMap,
    }
    "server/src/lib/tool-validate" --> "server/src/providers/openai-compat" {
        invalidToolCallReasons,
        isToolArgumentValidationEnabled,
    }
    "server/src/services/provider-quota" --> "server/src/providers/openai-compat" {
        QuotaObservationContext,
        recordQuotaObservation,
        recordQuotaObservationsFromResponse,
    }
    "server/src/lib/provider-timeout" --> "server/src/providers/openai-compat" { providerTimeoutMs }
    "server/src/lib/error-classify" --> "server/src/providers/openai-compat" { isAbortLikeError }
    server.src.lib.content --> "server/src/providers/openai-compat" { contentToString }
    server.src.lib.credential --> "server/src/providers/openai-compat" {
        bearerAuthHeader,
        isAnonymousCredential,
    }
    server.src.db.index ++> "server/src/lib/tool-validate" { getSetting }
    "server/src/providers/openai-compat" --> "server/src/services/model-discovery" {
        OpenAICompatProvider,
    }
    "server/src/lib/error-classify" --> "server/src/services/model-discovery" { isAbortLikeError }
    server.src.services.scoring --> "server/src/services/custom-model-seed" {
        TIER_VALUE,
        tierValue,
    }
    server.src.db.types --> "server/src/services/custom-model-seed" { Db }
    server.src.db.types --> "server/src/services/profile-models" { Db }
    server.src.db.types --> "server/src/services/custom-model-sync" { Db }
    server.src.lib.scheduler --> "server/src/services/custom-model-sync" { Scheduler }
    "server/src/services/model-discovery" --> "server/src/services/custom-model-sync" {
        discoverEndpointModels,
    }
    "server/src/services/custom-model-register" --> "server/src/services/custom-model-sync" {
        CustomModelEntry,
        registerCustomModels,
    }
    "server/src/services/custom-model-tombstone" --> "server/src/services/custom-model-sync" {
        isCustomModelTombstoned,
    }
    "server/src/services/custom-endpoint" --> "server/src/services/custom-model-sync" {
        listCustomEndpoints,
    }
    "server/src/lib/endpoint-scope" --> "server/src/services/custom-model-sync" {
        endpointScopeForBaseUrl,
    }
    server.src.db.types --> "server/src/services/custom-model-register" { Db }
    "server/src/services/custom-endpoint" --> "server/src/services/custom-model-register" {
        customEndpointKeyIds,
        resolveCustomEndpointKey,
    }
    "server/src/services/custom-model-seed" --> "server/src/services/custom-model-register" {
        customModelSeed,
    }
    "server/src/services/profile-models" --> "server/src/services/custom-model-register" {
        ensureModelInProfiles,
    }
    "server/src/services/custom-model-tombstone" --> "server/src/services/custom-model-register" {
        clearCustomModelTombstone,
    }
    "server/src/lib/endpoint-scope" --> "server/src/services/custom-model-register" {
        endpointScopeForBaseUrl,
    }
    server.src.lib.crypto --> "server/src/services/custom-endpoint" { decrypt, encrypt }
    server.src.db.types --> "server/src/services/custom-endpoint" { Db }
    server.src.db.types --> "server/src/services/custom-model-tombstone" { Db }
    server.src.providers.base --> server.src.providers.speechify {
        BaseProvider,
        KeyValidationResult,
        providerHttpError,
    }
    server.src.providers.base --> server.src.providers.typhoon {
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.typhoon { OpenAICompatProvider }
    "server/src/lib/provider-timeout" --> server.src.providers.typhoon { providerTimeoutMs }
    "server/src/services/provider-quota" --> server.src.providers.typhoon {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    server.src.providers.base --> server.src.providers.electronhub { CompletionOptions }
    "server/src/services/provider-quota" --> server.src.providers.electronhub {
        QuotaObservationContext,
    }
    server.src.lib.content --> server.src.providers.electronhub { contentToString }
    "server/src/providers/openai-compat" --> server.src.providers.electronhub {
        OpenAICompatProvider,
    }
    server.src.providers.base --> server.src.providers.silvr {
        CompletionOptions,
        KeyValidationResult,
        ProviderFetchOptions,
    }
    "server/src/providers/openai-compat" --> server.src.providers.silvr { OpenAICompatProvider }
    "server/src/services/provider-quota" --> server.src.providers.silvr { QuotaObservationContext }
    server.src.providers.base --> server.src.providers.freeai { BaseProvider, KeyValidationResult }
    server.src.providers.base --> server.src.providers.kenari {
        CompletionOptions,
        KeyValidationResult,
        ProviderFetchOptions,
        providerHttpError,
        providerRequestError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.kenari { OpenAICompatProvider }
    "server/src/services/provider-quota" --> server.src.providers.kenari { QuotaObservationContext }
    server.src.providers.base --> server.src.providers.plugsky {
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.plugsky { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.novai {
        CompletionOptions,
        KeyValidationResult,
        providerRequestError,
    }
    "server/src/services/provider-quota" --> server.src.providers.novai { QuotaObservationContext }
    "server/src/providers/openai-compat" --> server.src.providers.novai { OpenAICompatProvider }
    server.src.lib.proxy --> "server/src/services/media-varosity" { proxyFetch }
    "server/src/lib/url-guard" --> "server/src/services/media-varosity" { assessProviderUrl }
    "server/src/lib/image-normalize" --> "server/src/services/media-varosity" { cpuCanRunSharp }
    server.src.providers.base --> "server/src/services/media-varosity" { parseRetryAfterMs }
    server.src.providers.varosity --> "server/src/services/media-varosity" { VAROSITY_BASE_URL }
    server.src.services.media --> "server/src/services/media-varosity" {
        ImageParams,
        SpeechParams,
        VideoParams,
    }
    server.src.providers.base --> server.src.providers.varosity {
        BaseProvider,
        KeyValidationResult,
        providerHttpError,
    }
    server.src.lib.proxy --> "server/src/services/media-rime" { openProviderWebSocket, proxyFetch }
    server.src.providers.base --> "server/src/services/media-rime" { parseRetryAfterMs }
    server.src.services.media --> "server/src/services/media-rime" {
        SpeechParams,
        TranscriptionParams,
    }
    server.src.lib.proxy --> "server/src/services/media-google-live" { openProviderWebSocket }
    "server/src/services/media-rime" --> "server/src/services/media-google-live" {
        RimeMediaError,
        rimePcm,
    }
    server.src.services.media --> "server/src/services/media-google-live" { TranscriptionParams }
    server.src.lib.proxy --> "server/src/services/media-solaria" {
        openProviderWebSocket,
        proxyFetch,
    }
    server.src.providers.base --> "server/src/services/media-solaria" { parseRetryAfterMs }
    server.src.services.media --> "server/src/services/media-solaria" { TranscriptionParams }
    "server/src/services/media-rime" --> "server/src/services/media-solaria" {
        RimeMediaError,
        rimePcm,
    }
    server.src.lib.proxy --> "server/src/services/media-freetts" { proxyFetch }
    server.src.providers.base --> "server/src/services/media-freetts" { parseRetryAfterMs }
    server.src.services.media --> "server/src/services/media-freetts" { SpeechParams }
    server.src.lib.proxy --> "server/src/services/media-voice-gateways" {
        openProviderWebSocket,
        proxyFetch,
    }
    server.src.providers.base --> "server/src/services/media-voice-gateways" { parseRetryAfterMs }
    "server/src/services/media-rime" --> "server/src/services/media-voice-gateways" {
        RimeMediaError,
        rimePcm,
    }
    server.src.services.media --> "server/src/services/media-voice-gateways" {
        SpeechParams,
        TranscriptionParams,
    }
    server.src.db.index --> server.src.services.search { getDb, getSetting, setSetting }
    server.src.providers.base --> server.src.services.search {
        parseRetryAfterMs,
        parseStatedRetryMs,
    }
    "server/src/lib/retry-hint" --> server.src.services.search { RetryHintTracker }
    "server/src/lib/client-context" --> server.src.services.search { getClientContext }
    server.src.lib.proxy --> server.src.services.search { proxyFetch }
    "server/src/lib/search-platforms" --> server.src.services.search { isSearchPlatform }
    server.src.providers.tavily --> server.src.services.search { TAVILY_BASE_URL }
    server.src.providers.serpsearch --> server.src.services.search { SERPSEARCH_BASE_URL }
    server.src.providers.brave --> server.src.services.search { BRAVE_BAD_KEY_CODE, BRAVE_BASE_URL }
    server.src.providers.exa --> server.src.services.search { EXA_BASE_URL }
    server.src.providers.firecrawl --> server.src.services.search { FIRECRAWL_BASE_URL }
    server.src.providers.linkup --> server.src.services.search { LINKUP_BASE_URL }
    server.src.providers.parallel --> server.src.services.search {
        PARALLEL_BASE_URL,
        PARALLEL_MCP_URL,
    }
    server.src.providers.keenable --> server.src.services.search {
        KEENABLE_APP_TITLE,
        KEENABLE_BASE_URL,
    }
    server.src.providers.outcrawl --> server.src.services.search { OUTCRAWL_BASE_URL }
    server.src.providers.tinyfish --> server.src.services.search { TINYFISH_SEARCH_URL }
    server.src.lib.credential --> server.src.services.search { isAnonymousCredential }
    "server/src/services/key-budget" --> server.src.services.search { secondsUntilNextMonth }
    "server/src/services/budget-alerts" --> server.src.services.search { noteBudgetAlerts }
    "server/src/services/provider-credential" --> server.src.services.search {
        ReservedProviderCredential,
        reserveProviderCredential,
    }
    server.src.services.ratelimit --> server.src.services.search { isOnCooldown, setCooldown }
    server.src.services.health --> server.src.services.search { markKeyHealthyFromRequest }
    server.src.providers.base --> server.src.providers.tavily { KeyValidationResult }
    "server/src/providers/search-only" --> server.src.providers.tavily { SearchOnlyProvider }
    server.src.providers.base --> "server/src/providers/search-only" {
        BaseProvider,
        CompletionOptions,
        KeyValidationResult,
    }
    server.src.lib.proxy --> "server/src/providers/search-only" { proxyFetch }
    server.src.providers.base --> server.src.providers.serpsearch { KeyValidationResult }
    "server/src/providers/search-only" --> server.src.providers.serpsearch { SearchOnlyProvider }
    server.src.providers.base --> server.src.providers.brave { KeyValidationResult }
    "server/src/providers/search-only" --> server.src.providers.brave { SearchOnlyProvider }
    server.src.lib.proxy --> server.src.providers.brave { proxyFetch }
    server.src.providers.base --> server.src.providers.exa { KeyValidationResult }
    "server/src/providers/search-only" --> server.src.providers.exa { SearchOnlyProvider }
    server.src.providers.base --> server.src.providers.firecrawl { KeyValidationResult }
    "server/src/providers/search-only" --> server.src.providers.firecrawl { SearchOnlyProvider }
    server.src.providers.base --> server.src.providers.linkup { KeyValidationResult }
    "server/src/providers/search-only" --> server.src.providers.linkup { SearchOnlyProvider }
    server.src.providers.base --> server.src.providers.parallel { KeyValidationResult }
    "server/src/providers/search-only" --> server.src.providers.parallel { SearchOnlyProvider }
    server.src.lib.credential --> server.src.providers.parallel { isAnonymousCredential }
    server.src.providers.base --> server.src.providers.keenable { KeyValidationResult }
    "server/src/providers/search-only" --> server.src.providers.keenable { SearchOnlyProvider }
    server.src.lib.credential --> server.src.providers.keenable { isAnonymousCredential }
    server.src.providers.base --> server.src.providers.outcrawl { KeyValidationResult }
    "server/src/providers/search-only" --> server.src.providers.outcrawl { SearchOnlyProvider }
    server.src.providers.base --> server.src.providers.tinyfish { KeyValidationResult }
    "server/src/providers/search-only" --> server.src.providers.tinyfish { SearchOnlyProvider }
    server.src.db.index --> server.src.services.decision { getDb }
    server.src.providers.beatapi --> server.src.services.decision { BEATAPI_BASE_URL }
    server.src.providers.apinex --> server.src.services.decision { APINEX_BASE_URL }
    server.src.providers.blockrun --> server.src.services.decision { BLOCKRUN_BASE_URL }
    server.src.providers.silvr --> server.src.services.decision { SILVR_BASE_URL }
    server.src.providers.base --> server.src.services.decision {
        parseRetryAfterMs,
        parseStatedRetryMs,
    }
    "server/src/lib/retry-hint" --> server.src.services.decision { RetryHintTracker }
    "server/src/lib/client-context" --> server.src.services.decision { getClientContext }
    server.src.lib.proxy --> server.src.services.decision { proxyFetch }
    "server/src/services/key-budget" --> server.src.services.decision {
        recordMonthlyUsage,
        secondsUntilNextMonth,
    }
    "server/src/services/budget-alerts" --> server.src.services.decision { noteBudgetAlerts }
    "server/src/services/provider-credential" --> server.src.services.decision {
        ReservedProviderCredential,
        reserveProviderCredential,
    }
    "server/src/services/cloudflare-neurons" --> server.src.services.decision {
        CloudflareNeuronCapError,
        meterCloudflare,
        roughTokens,
    }
    server.src.services.ratelimit --> server.src.services.decision { isOnCooldown, setCooldown }
    server.src.services.health --> server.src.services.decision { markKeyHealthyFromRequest }
    server.src.providers.base --> server.src.providers.beatapi {
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.beatapi { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.apinex {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.apinex { OpenAICompatProvider }
    "server/src/services/provider-quota" --> server.src.providers.apinex { QuotaObservationContext }
    server.src.providers.base --> server.src.providers.blockrun {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.blockrun { OpenAICompatProvider }
    "server/src/services/provider-quota" --> server.src.providers.blockrun {
        QuotaObservationContext,
    }
    server.src.db.index --> server.src.services.embeddings { getDb, getSetting }
    "server/src/services/key-budget" --> server.src.services.embeddings { secondsUntilNextMonth }
    "server/src/services/budget-alerts" --> server.src.services.embeddings { noteBudgetAlerts }
    server.src.providers.base --> server.src.services.embeddings { parseRetryAfterMs }
    "server/src/lib/retry-hint" --> server.src.services.embeddings {
        RetryHintTracker,
        retryAfterSeconds,
    }
    "server/src/lib/client-context" --> server.src.services.embeddings { getClientContext }
    "server/src/services/provider-credential" --> server.src.services.embeddings {
        reserveProviderCredential,
    }
    server.src.services.ratelimit --> server.src.services.embeddings {
        acquireLease,
        canMakeRequest,
        canUseTokens,
        getProviderMinuteRequestCap,
        recordRequest,
        recordTokens,
        releaseLease,
        setCooldown,
    }
    "server/src/services/cloudflare-neurons" --> server.src.services.embeddings {
        meterCloudflare,
        roughTokens,
    }
    server.src.lib.proxy --> server.src.services.embeddings { proxyFetch }
    server.src.lib.credential --> server.src.services.embeddings { bearerAuthHeader }
    server.src.services.health --> server.src.services.embeddings { markKeyHealthyFromRequest }
    "server/src/services/custom-endpoint" --> server.src.services.embeddings {
        customEndpointKeyIds,
    }
    server.src.db.types --> server.src.services.embeddings { Db }
    server.src.providers.speka --> server.src.services.embeddings { SPEKA_BASE_URL }
    server.src.providers.electronhub --> server.src.services.embeddings { ELECTRONHUB_BASE_URL }
    server.src.providers.inferbase --> server.src.services.embeddings { INFERBASE_BASE_URL }
    server.src.providers.llmtr --> server.src.services.embeddings { LLMTR_BASE_URL }
    server.src.providers.jamai --> server.src.services.embeddings { JAMAI_BASE_URL, jamaiHeaders }
    server.src.providers.freeinference --> server.src.services.embeddings { FREEINFERENCE_BASE_URL }
    server.src.providers.freeai --> server.src.services.embeddings { FREEAI_BASE_URL }
    server.src.providers.silvr --> server.src.services.embeddings { SILVR_BASE_URL }
    server.src.providers.base --> server.src.providers.speka {
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.speka { OpenAICompatProvider }
    "server/src/lib/provider-timeout" --> server.src.providers.speka { providerTimeoutMs }
    "server/src/services/provider-quota" --> server.src.providers.speka {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    server.src.providers.base --> server.src.providers.inferbase {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.inferbase {
        QuotaObservationContext,
    }
    "server/src/providers/openai-compat" --> server.src.providers.inferbase { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.llmtr {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.llmtr { OpenAICompatProvider }
    "server/src/lib/provider-timeout" --> server.src.providers.llmtr { providerTimeoutMs }
    "server/src/services/provider-quota" --> server.src.providers.llmtr {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    server.src.providers.base --> server.src.providers.jamai {
        BaseProvider,
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/lib/sampling-params" --> server.src.providers.jamai { resolveMaxTokens }
    "server/src/lib/provider-timeout" --> server.src.providers.jamai { providerTimeoutMs }
    "server/src/services/provider-quota" --> server.src.providers.jamai {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    server.src.providers.base --> server.src.providers.freeinference {
        CompletionOptions,
        KeyValidationResult,
        ProviderFetchOptions,
        providerRequestError,
    }
    "server/src/services/provider-quota" --> server.src.providers.freeinference {
        QuotaObservationContext,
    }
    "server/src/providers/openai-compat" --> server.src.providers.freeinference {
        OpenAICompatProvider,
    }
    server.src.db.types --> "server/src/services/keyless-defaults" { Db }
    server.src.db.index --> "server/src/services/keyless-defaults" { getDb, getSetting, setSetting }
    server.src.lib.crypto --> "server/src/services/keyless-defaults" { encrypt }
    server.src.providers.index --> "server/src/services/keyless-defaults" { getAllProviders }
    server.src.db.index --> "server/src/lib/min-context-window" { getSetting }
    server.src.db.index --> "server/src/services/model-groups" { getDb, getSetting, setSetting }
    "server/src/lib/endpoint-scope" --> "server/src/services/model-groups" {
        ENDPOINT_ID_SEPARATOR,
        endpointRefMatches,
        groupRefMatches,
        qualifiedModelMemberId,
    }
    "server/src/lib/endpoint-scope" --> "server/src/lib/tool-capability" { modelStatsKey }
    "server/src/services/key-budget" --> "server/src/lib/fallback-loop" { nextMonthResetAt }
    "server/src/services/cloudflare-daily-quota" --> "server/src/lib/fallback-loop" {
        benchCloudflareAccount,
    }
    server.src.services.router --> "server/src/lib/fallback-loop" {
        RouteResult,
        formatResetEta,
        hasOtherUsableKey,
        isProviderMomentAttributionEnabled,
        recordModelFailure,
        recordRateLimitHit,
        recordSuccess,
        routableKeyIdsForModel,
    }
    "server/src/lib/header-value" --> "server/src/lib/fallback-loop" { safeHeaderValue }
    server.src.services.ratelimit --> "server/src/lib/fallback-loop" {
        CooldownDecision,
        CooldownSource,
        getActiveCooldownsForKeys,
        getCooldownDecisionForLimit,
        getModelForbiddenCooldownMs,
        getPaymentRequiredCooldownMs,
        getSoonestCooldownExpiry,
        learnContextWindowFromError,
        learnLimitFromError,
        pacificMidnight,
        recordRequest,
        recordTokens,
        setCooldown,
    }
    "server/src/lib/error-classify" --> "server/src/lib/fallback-loop" {
        isAccountSuspendedError,
        isClientAbortError,
        isContextTooLargeError,
        isDailyQuotaExhaustedError,
        isHedgeAbortError,
        isKeyAuthError,
        isModelAccessForbiddenError,
        isModelNotFoundError,
        isModelScopedOverloadError,
        isPaymentRequiredError,
        isProviderBadRequestError,
        isProviderDegradedError,
        isProviderLevelError,
        isProviderMomentFailure,
        isRateLimitSignal,
        isRetryableError,
        isStreamTruncatedError,
        isTimeoutErrorText,
    }
    "server/src/lib/error-redaction" --> "server/src/lib/fallback-loop" {
        sanitizeProviderErrorMessage,
        summarizeAttemptError,
    }
    "server/src/lib/tool-capability" --> "server/src/lib/fallback-loop" {
        benchForTools,
        clearToolRejections,
        noteToolRejection,
        toolCapabilityKey,
    }
    "server/src/lib/provider-size-parser" --> "server/src/lib/fallback-loop" {
        parseProviderReportedSize,
    }
    server.src.services.health --> "server/src/lib/fallback-loop" {
        checkKeyHealth,
        markKeyHealthyFromRequest,
    }
    server.src.db.index --> "server/src/lib/fallback-loop" { getDb, getSetting }
    server.src.lib.guardrails --> "server/src/lib/fallback-loop" {
        newBreaker,
        recordBreakerFailure,
    }
    "server/src/lib/attempt-trace" --> "server/src/lib/fallback-loop" {
        AttemptOutcome,
        AttemptTraceRecord,
        RequestTrace,
        getRequestTrace,
        newRequestTrace,
        runWithRequestTrace,
    }
    "server/src/lib/request-log" --> "server/src/lib/fallback-loop" {
        logRequest,
        persistRequestAttempts,
    }
    server.src.lib.proxy --> "server/src/lib/fallback-loop" { withKeyProxy }
    "server/src/lib/upstream-watch" --> "server/src/lib/fallback-loop" {
        UpstreamStreamWatch,
        runWithUpstreamWatch,
    }
    "server/src/lib/ttfb-budget" --> "server/src/lib/fallback-loop" { getEndpointTimeBudgetMs }
    "server/src/lib/output-cap" --> "server/src/lib/fallback-loop" {
        learnOutputCapFromError,
        learnedOutputCap,
    }
    server.src.db.index ++> "server/src/services/model-retirement" { getDb }
    "server/src/lib/error-classify" ++> "server/src/services/model-retirement" {
        modelRetirementSignal,
    }
    "server/src/lib/error-redaction" ++> "server/src/services/model-retirement" {
        summarizeAttemptError,
    }
    "server/src/services/model-state" ++> "server/src/services/model-retirement" {
        isCatalogManagedModel,
        retireCatalogModelUpstream,
    }
    "server/src/lib/endpoint-scope" ++> "server/src/services/model-retirement" { modelStatsKey }
    "server/src/lib/server-logs" ++> "server/src/services/model-retirement" { providerLog }
    server.src.db.index ++> server.src.lib.guardrails { getSetting }
    server.src.db.index ++> "server/src/lib/request-log" { getDb }
    "server/src/services/request-retention" ++> "server/src/lib/request-log" {
        pruneRequestAnalytics,
    }
    "server/src/services/budget-alerts" ++> "server/src/lib/request-log" { noteBudgetAlerts }
    "server/src/lib/client-context" ++> "server/src/lib/request-log" { getClientContext }
    "server/src/lib/attempt-trace" ++> "server/src/lib/request-log" { noteRequestRowId }
    server.src.db.index --> "server/src/services/request-retention" { getDb }
    server.src.db.index ++> "server/src/lib/ttfb-budget" { getDb }
    "server/src/lib/endpoint-scope" ++> "server/src/lib/ttfb-budget" { endpointScopeForBaseUrl }
    "server/src/lib/endpoint-scope" ++> "server/src/lib/output-cap" { modelStatsKey }
    "server/src/services/specialist-text" --> server.src.routes.proxy {
        listSpecialists,
        serveSpecialist,
    }
    server.src.services.router --> server.src.routes.proxy {
        ChainRow,
        ResolvedChain,
        RouteResult,
        failureAttributionFor,
        hasEnabledToolsModel,
        hasEnabledVisionModel,
        resolveModelGroupCandidates,
        resolveRoutingChain,
        resolveStickyPreference,
        routeRequest,
        routingReserveTokens,
    }
    "server/src/services/key-budget" --> server.src.routes.proxy {
        nextMonthResetAt,
        secondsUntilNextMonth,
    }
    server.src.services.embeddings --> server.src.routes.proxy { EmbeddingsError, runEmbeddings }
    server.src.services.rerank --> server.src.routes.proxy {
        RerankError,
        rerankRetryAfterSec,
        runRerank,
    }
    server.src.services.search --> server.src.routes.proxy {
        SearchError,
        listSearchEngines,
        runSearch,
        searchRetryAfterSec,
    }
    server.src.services.decision --> server.src.routes.proxy {
        DECISION_QUESTION_TYPES,
        DecisionError,
        decisionRetryAfterSec,
        listDecisionModels,
        runDecision,
    }
    "server/src/lib/retry-hint" --> server.src.routes.proxy { retryAfterSeconds }
    server.src.services.media --> server.src.routes.proxy {
        MAX_TRANSCRIPTION_BYTES,
        MediaError,
        runImageGeneration,
        runSpeech,
        runTranscription,
        runVideoGeneration,
    }
    server.src.db.index --> server.src.routes.proxy { getDb }
    "server/src/lib/system-prompt" --> server.src.routes.proxy {
        ResolvedAuth,
        prependSystemPrompt,
        resolveAuth,
        timingSafeStringEqual,
    }
    "server/src/lib/system-date" --> server.src.routes.proxy { maybeInjectSystemDate }
    server.src.lib.content --> server.src.routes.proxy {
        contentToString,
        estimateInputTokens,
        messageHasImage,
        normalizeOutboundContent,
        sanitizeResponse,
    }
    "server/src/lib/output-cap" --> server.src.routes.proxy { routeOutputBudget }
    "server/src/lib/task-type" --> server.src.routes.proxy { resolveTaskType }
    "server/src/lib/image-normalize" --> server.src.routes.proxy { normalizeMessageImages }
    "server/src/lib/tool-args" --> server.src.routes.proxy { repairToolArguments, toolSchemaMap }
    "server/src/lib/tool-validate" --> server.src.routes.proxy {
        invalidToolArgumentsError,
        invalidToolCallReasons,
        isToolArgumentValidationEnabled,
    }
    "server/src/lib/error-redaction" --> server.src.routes.proxy { sanitizeProviderErrorMessage }
    "server/src/lib/tool-call-rescue" --> server.src.routes.proxy {
        containsDialectMarker,
        couldBecomeDialectMarker,
        rescueInlineToolCalls,
        startsWithDialectMarker,
    }
    "server/src/services/context-handoff" --> server.src.routes.proxy {
        HANDOFF_MAX_TOKENS,
        getContextHandoffMode,
        hasPriorModel,
        maybeInjectContextHandoff,
        recordIncomingMessages,
        recordSuccessfulModel,
    }
    server.src.services.fusion --> server.src.routes.proxy {
        FUSION_MODEL_ID,
        FusionError,
        fusionConfigSchema,
        isFusionModel,
        runFusion,
    }
    "server/src/lib/error-classify" --> server.src.routes.proxy {
        isClientAbortError,
        isModelAccessForbiddenError,
        isModelNotFoundError,
        isPaymentRequiredError,
        isRetryableError,
        isUpstreamClassificationOutput,
        newClientAbortError,
        newHedgeAbortError,
    }
    "server/src/lib/request-log" --> server.src.routes.proxy { logRequest }
    "server/src/lib/served-model" --> server.src.routes.proxy { observeServedModel }
    server.src.services.cache --> server.src.routes.proxy {
        STREAM_CACHE_MAX_BYTES,
        cacheActive,
        computeCacheKey,
        getCachedResponse,
        getCachedStreamResponse,
        isCacheableTemperature,
        parseCacheDirective,
        storeCachedResponse,
        storeCachedStreamResponse,
    }
    server.src.services.idempotency --> server.src.routes.proxy {
        computeIdempotencyFingerprint,
        hashIdempotencyKey,
        lookupIdempotencyReplay,
        normalizeIdempotencyKey,
        storeIdempotencyResult,
    }
    "server/src/lib/fallback-loop" --> server.src.routes.proxy {
        AttemptRecord,
        REASONING_HOLD_MAX_MS,
        exhaustedRetryError,
        exhaustionErrorPayload,
        fallbackRoutingTokens,
        newFallbackState,
        recordUpstreamSuccess,
        runFallbackLoop,
        setExhaustionHeaders,
        setFallbackHeaders,
    }
    "server/src/lib/header-value" --> server.src.routes.proxy { routedViaValue, safeHeaderValue }
    server.src.lib.guardrails --> server.src.routes.proxy { applyTokenBudget, tokenBudgetMessage }
    "server/src/lib/sampling-params" --> server.src.routes.proxy {
        pickSamplingParams,
        samplingParamSchemaFields,
        supportedParametersForPlatforms,
    }
    "server/src/lib/structured-output" --> server.src.routes.proxy { enforceJsonContent }
    "server/src/services/provider-quota" --> server.src.routes.proxy {
        QuotaObservationContext,
        inferQuotaPoolKey,
    }
    "server/src/services/model-groups" --> server.src.routes.proxy {
        getModelGroups,
        isUnifyEnabled,
        resolveRequestedIdForDispatch,
    }
    "server/src/services/model-listing" --> server.src.routes.proxy {
        NormalizedModel,
        advertisedContextWindow,
        buildModelListing,
        servableContextWindow,
    }
    "server/src/services/codex-catalog" --> server.src.routes.proxy { buildCodexCatalog }
    "server/src/services/anthropic-map" --> server.src.routes.proxy {
        claudeFamilyDiscoveryEntries,
        resolveListedClaudeAlias,
    }
    server.src.services.compression.pipeline --> server.src.routes.proxy {
        compressRequest,
        formatCompressionHeader,
    }
    "server/src/services/routing-decision" --> server.src.routes.proxy {
        applyDecisionRouting,
        routingStrategyHeader,
    }
    "server/src/lib/stream-keepalive" --> server.src.routes.proxy {
        startStreamKeepalive,
        streamKeepaliveMs,
    }
    server.src.db.index --> server.src.services.rerank { getDb }
    server.src.lib.crypto --> server.src.services.rerank { decrypt }
    server.src.providers.base --> server.src.services.rerank { parseRetryAfterMs }
    "server/src/lib/model-scope" --> server.src.services.rerank { parseModelScope, scopeAllows }
    "server/src/services/key-budget" --> server.src.services.rerank {
        checkMonthlyBudget,
        reserveMonthlyBudget,
        secondsUntilNextMonth,
    }
    "server/src/services/budget-alerts" --> server.src.services.rerank { noteBudgetAlerts }
    server.src.services.health --> server.src.services.rerank { markKeyHealthyFromRequest }
    "server/src/lib/client-context" --> server.src.services.rerank { getClientContext }
    server.src.lib.proxy --> server.src.services.rerank { proxyFetch }
    server.src.db.index ++> "server/src/lib/system-prompt" { getDb, getUnifiedApiKey }
    server.src.db.index ++> "server/src/lib/system-date" { getSetting, setSetting }
    server.src.lib.content ++> "server/src/lib/system-date" { contentToString }
    server.src.lib.content ++> "server/src/lib/task-type" { contentToString }
    server.src.lib.content --> "server/src/services/context-handoff" { contentToString }
    server.src.services.router --> server.src.services.fusion {
        FusionCandidate,
        RouteResult,
        failureAttributionFor,
        getOrderedFusionChain,
        pinnedModelFitsRequestSize,
        recordRateLimitHit,
        recordSuccess,
        resolveFusionCandidate,
        routePinnedModel,
        routeRequest,
    }
    server.src.services.ratelimit --> server.src.services.fusion {
        getCooldownDecisionForLimit,
        getCooldownDurationForLimit,
        getModelForbiddenCooldownMs,
        getPaymentRequiredCooldownMs,
        learnContextWindowFromError,
        learnLimitFromError,
        recordRequest,
        recordTokens,
        setCooldown,
    }
    "server/src/lib/request-log" --> server.src.services.fusion { logRequest }
    "server/src/lib/error-classify" --> server.src.services.fusion {
        isContextTooLargeError,
        isDailyQuotaExhaustedError,
        isModelAccessForbiddenError,
        isModelNotFoundError,
        isPaymentRequiredError,
        isRateLimitSignal,
        isRetryableError,
    }
    server.src.lib.content --> server.src.services.fusion {
        contentToString,
        stripImagesFromMessages,
    }
    "server/src/lib/error-redaction" --> server.src.services.fusion { sanitizeProviderErrorMessage }
    server.src.db.index --> server.src.services.fusion { getSetting, setSetting }
    server.src.providers.base --> server.src.services.fusion { CompletionOptions }
    "server/src/lib/output-cap" --> server.src.services.fusion { routeOutputBudget }
    server.src.db.index --> server.src.services.cache { getDb, getSetting }
    server.src.db.index --> server.src.services.idempotency { getDb }
    server.src.db.index --> "server/src/services/model-listing" { getDb }
    "server/src/services/model-groups" --> "server/src/services/model-listing" {
        getModelGroups,
        isUnifyEnabled,
    }
    server.src.services.router --> "server/src/services/model-listing" {
        CONTEXT_WINDOW_SAFETY_FACTOR,
        hasUsableKeyForModel,
    }
    "server/src/services/codex-base-instructions" --> "server/src/services/codex-catalog" {
        CODEX_BASE_INSTRUCTIONS,
    }
    server.src.db.index --> "server/src/services/anthropic-map" { getDb, getSetting, setSetting }
    server.src.services.compression.engines.index --> server.src.services.compression.pipeline;
    server.src.services.compression.config --> server.src.services.compression.pipeline {
        compressionConfigFingerprint,
        getCompressionConfig,
        parseCompressionDirective,
        resolveCompressionMode,
    }
    "server/src/services/compression/fidelity-gate" --> server.src.services.compression.pipeline {
        checkFidelity,
    }
    server.src.services.compression.helpers --> server.src.services.compression.pipeline {
        buildToolCallOrigins,
        estimateTokensFromChars,
        messageChars,
        textContent,
    }
    server.src.services.compression.registry --> server.src.services.compression.pipeline {
        getRegisteredEngines,
    }
    server.src.services.compression.stats --> server.src.services.compression.pipeline {
        recordCompressionStats,
    }
    server.src.services.compression.types --> server.src.services.compression.pipeline {
        CompressRequestOptions,
        CompressionEngineConfig,
        CompressionMode,
        CompressionRequestStats,
        CompressionResult,
        CompressionStageStats,
    }
    server.src.services.compression.engines.dedup --> server.src.services.compression.engines.index;
    server.src.services.compression.engines.lite --> server.src.services.compression.engines.index;
    "server/src/services/compression/engines/read-lifecycle" --> server.src.services.compression.engines.index;
    server.src.services.compression.engines.toolfilter --> server.src.services.compression.engines.index;
    server.src.services.compression.engines.jsoncompact --> server.src.services.compression.engines.index;
    server.src.services.compression.engines.relevance --> server.src.services.compression.engines.index;
    server.src.services.compression.engines.aging --> server.src.services.compression.engines.index;
    "server/src/services/compression/engines/hard-budget" --> server.src.services.compression.engines.index;
    server.src.services.compression.registry --> server.src.services.compression.engines.dedup {
        registerEngine,
    }
    server.src.services.compression.helpers --> server.src.services.compression.engines.dedup {
        textContent,
        withTextContent,
    }
    server.src.services.compression.types --> server.src.services.compression.engines.dedup {
        CompressionEngine,
    }
    server.src.services.compression.types --> server.src.services.compression.registry {
        CompressionEngine,
    }
    server.src.services.compression.types --> server.src.services.compression.helpers {
        ToolCallOrigin,
    }
    server.src.services.compression.registry --> server.src.services.compression.engines.lite {
        registerEngine,
    }
    server.src.services.compression.helpers --> server.src.services.compression.engines.lite {
        textContent,
        withTextContent,
    }
    server.src.services.compression.preservation --> server.src.services.compression.engines.lite {
        transformUnprotectedText,
    }
    server.src.services.compression.types --> server.src.services.compression.engines.lite {
        CompressionEngine,
    }
    server.src.services.compression.registry --> "server/src/services/compression/engines/read-lifecycle" {
        registerEngine,
    }
    server.src.services.compression.helpers --> "server/src/services/compression/engines/read-lifecycle" {
        textContent,
        withTextContent,
    }
    server.src.services.compression.types --> "server/src/services/compression/engines/read-lifecycle" {
        CompressionEngine,
        ToolCallOrigin,
    }
    server.src.services.compression.registry --> server.src.services.compression.engines.toolfilter {
        registerEngine,
    }
    server.src.services.compression.preservation --> server.src.services.compression.engines.toolfilter {
        hasProtectedSpan,
    }
    server.src.services.compression.helpers --> server.src.services.compression.engines.toolfilter {
        textContent,
        withTextContent,
    }
    "server/src/services/compression/engines/filter-definitions" --> server.src.services.compression.engines.toolfilter {
        BUILTIN_FILTERS,
        ToolFilterRule,
    }
    "server/src/services/compression/engines/custom-filters" --> server.src.services.compression.engines.toolfilter {
        loadCustomFilters,
    }
    server.src.services.compression.types --> server.src.services.compression.engines.toolfilter {
        CompressionEngine,
        ToolCallOrigin,
    }
    "server/src/services/compression/engines/filter-definitions" --> "server/src/services/compression/engines/custom-filters" {
        ToolFilterRule,
        filterRuleSchema,
    }
    server.src.services.compression.registry --> server.src.services.compression.engines.jsoncompact {
        registerEngine,
    }
    server.src.services.compression.helpers --> server.src.services.compression.engines.jsoncompact {
        textContent,
        withTextContent,
    }
    server.src.services.compression.types --> server.src.services.compression.engines.jsoncompact {
        CompressionEngine,
    }
    server.src.services.compression.registry --> server.src.services.compression.engines.relevance {
        registerEngine,
    }
    server.src.services.compression.preservation --> server.src.services.compression.engines.relevance {
        hasProtectedContent,
    }
    server.src.services.compression.helpers --> server.src.services.compression.engines.relevance {
        textContent,
        withTextContent,
    }
    server.src.services.compression.types --> server.src.services.compression.engines.relevance {
        CompressionEngine,
    }
    server.src.services.compression.registry --> server.src.services.compression.engines.aging {
        registerEngine,
    }
    server.src.services.compression.preservation --> server.src.services.compression.engines.aging {
        scanProtectedSpans,
    }
    server.src.services.compression.helpers --> server.src.services.compression.engines.aging {
        textContent,
        withTextContent,
    }
    server.src.services.compression.types --> server.src.services.compression.engines.aging {
        CompressionEngine,
    }
    server.src.services.compression.registry --> "server/src/services/compression/engines/hard-budget" {
        registerEngine,
    }
    server.src.services.compression.preservation --> "server/src/services/compression/engines/hard-budget" {
        hasProtectedContent,
    }
    server.src.services.compression.helpers --> "server/src/services/compression/engines/hard-budget" {
        messageChars,
        textContent,
        withTextContent,
    }
    server.src.services.compression.types --> "server/src/services/compression/engines/hard-budget" {
        CompressionEngine,
    }
    server.src.db.index --> server.src.services.compression.config { getSetting, setSetting }
    server.src.services.compression.types --> server.src.services.compression.config {
        COMPRESSION_MODES,
        CompressionConfig,
        CompressionEngineConfig,
        CompressionMode,
    }
    server.src.services.compression.helpers --> "server/src/services/compression/fidelity-gate" {
        allMessageText,
        messageChars,
    }
    server.src.services.compression.preservation --> "server/src/services/compression/fidelity-gate" {
        extractProtectedValues,
        scanProtectedSpans,
    }
    server.src.services.compression.types --> server.src.services.compression.stats {
        CompressionMode,
        CompressionRequestStats,
    }
    server.src.db.index --> "server/src/services/routing-decision" { getSetting, setSetting }
    "server/src/lib/client-context" --> "server/src/services/routing-decision" {
        setRequestRoutingStrategy,
    }
    server.src.services.decision --> "server/src/services/routing-decision" {
        DecisionError,
        isClairic,
        listDecisionModels,
        runDecision,
    }
    server.src.services.router --> "server/src/services/routing-decision" { getRoutingStrategy }
    server.src.services.scoring --> "server/src/services/routing-decision" { PresetStrategy }
    server.src.providers.base --> server.src.providers.cohere {
        BaseProvider,
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/lib/sampling-params" --> server.src.providers.cohere {
        extendedBodyParams,
        resolveMaxTokens,
    }
    server.src.lib.content --> server.src.providers.cohere { flattenMessageContent }
    "server/src/services/provider-quota" --> server.src.providers.cohere {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    "server/src/lib/tool-args" --> server.src.providers.cohere { stripSchemaKeys }
    server.src.providers.base --> server.src.providers.llmkiwi {
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.llmkiwi { OpenAICompatProvider }
    server.src.providers.base --> "server/src/providers/decision-only" {
        BaseProvider,
        KeyValidationResult,
    }
    server.src.providers.base --> server.src.providers.cloudflare {
        BaseProvider,
        CompletionOptions,
        KeyValidationFailure,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/lib/sampling-params" --> server.src.providers.cloudflare {
        extendedBodyParams,
        resolveMaxTokens,
    }
    server.src.lib.content --> server.src.providers.cloudflare {
        contentHasImage,
        contentToString,
        estimateInputTokens,
    }
    "server/src/lib/think-tags" --> server.src.providers.cloudflare { extractThinkFromMessage }
    "server/src/services/provider-quota" --> server.src.providers.cloudflare {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    "server/src/lib/provider-timeout" --> server.src.providers.cloudflare { providerTimeoutMs }
    "server/src/services/cloudflare-neurons" --> server.src.providers.cloudflare {
        CloudflareNeuronCall,
        startCloudflareCall,
    }
    server.src.providers.base --> server.src.providers.aihorde {
        BaseProvider,
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.aihorde {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    "server/src/lib/provider-timeout" --> server.src.providers.aihorde { providerTimeoutMs }
    "server/src/lib/sampling-params" --> server.src.providers.aihorde { resolveMaxTokens }
    "server/src/providers/openai-compat" --> server.src.providers.modelscope {
        OpenAICompatProvider,
    }
    server.src.providers.base --> server.src.providers.modelscope { KeyValidationResult }
    "server/src/services/provider-quota" --> server.src.providers.modelscope {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    "server/src/providers/openai-compat" --> server.src.providers.pollinations {
        OpenAICompatProvider,
    }
    server.src.providers.base --> server.src.providers.pollinations { KeyValidationResult }
    "server/src/services/provider-quota" --> server.src.providers.pollinations {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    "server/src/providers/openai-compat" --> server.src.providers.zhipu { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.zhipu {
        KeyValidationResult,
        ProviderFetchOptions,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.zhipu { QuotaObservationContext }
    server.src.providers.base --> server.src.providers.puter {
        BaseProvider,
        CompletionOptions,
        providerHttpError,
    }
    server.src.providers.base --> server.src.providers.sail {
        BaseProvider,
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    server.src.lib.content --> server.src.providers.sail { contentToString }
    "server/src/lib/sampling-params" --> server.src.providers.sail { resolveMaxTokens }
    "server/src/services/provider-quota" --> server.src.providers.sail {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    "server/src/lib/provider-timeout" --> server.src.providers.sail { providerTimeoutMs }
    server.src.providers.base --> server.src.providers.aclide {
        BaseProvider,
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    server.src.lib.content --> server.src.providers.aclide { contentToString }
    "server/src/lib/provider-timeout" --> server.src.providers.aclide { providerTimeoutMs }
    "server/src/lib/sampling-params" --> server.src.providers.aclide { resolveMaxTokens }
    "server/src/services/provider-quota" --> server.src.providers.aclide {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    server.src.providers.base --> server.src.providers.kiosapi {
        CompletionOptions,
        KeyValidationResult,
        ProviderFetchOptions,
        providerRequestError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.kiosapi { OpenAICompatProvider }
    "server/src/services/provider-quota" --> server.src.providers.kiosapi {
        QuotaObservationContext,
    }
    server.src.providers.base --> server.src.providers.simplellm {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.simplellm {
        QuotaObservationContext,
    }
    "server/src/providers/openai-compat" --> server.src.providers.simplellm { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.gizmo {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
        providerRequestError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.gizmo { OpenAICompatProvider }
    "server/src/services/provider-quota" --> server.src.providers.gizmo { QuotaObservationContext }
    server.src.providers.base --> server.src.providers.moondream {
        BaseProvider,
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/lib/sampling-params" --> server.src.providers.moondream { resolveMaxTokens }
    "server/src/lib/provider-timeout" --> server.src.providers.moondream { providerTimeoutMs }
    "server/src/services/provider-quota" --> server.src.providers.moondream {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    server.src.providers.base --> server.src.providers.nabh {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.nabh { OpenAICompatProvider }
    "server/src/services/provider-quota" --> server.src.providers.nabh { QuotaObservationContext }
    server.src.providers.base --> server.src.providers.zro {
        CompletionOptions,
        KeyValidationResult,
        ProviderFetchOptions,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.zro { OpenAICompatProvider }
    "server/src/services/provider-quota" --> server.src.providers.zro { QuotaObservationContext }
    server.src.providers.base --> server.src.providers.freemodel {
        CompletionOptions,
        KeyValidationResult,
        ProviderFetchOptions,
    }
    "server/src/services/provider-quota" --> server.src.providers.freemodel {
        QuotaObservationContext,
    }
    "server/src/providers/openai-compat" --> server.src.providers.freemodel { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.experiential { CompletionOptions }
    "server/src/providers/openai-compat" --> server.src.providers.experiential {
        OpenAICompatProvider,
    }
    server.src.providers.base --> server.src.providers.router9 { KeyValidationResult }
    "server/src/providers/openai-compat" --> server.src.providers.router9 { OpenAICompatProvider }
    "server/src/services/provider-quota" --> server.src.providers.router9 {
        QuotaObservationContext,
        recordQuotaObservationsFromResponse,
    }
    server.src.providers.base --> server.src.providers.septor { CompletionOptions }
    "server/src/services/provider-quota" --> server.src.providers.septor { QuotaObservationContext }
    "server/src/providers/openai-compat" --> server.src.providers.septor { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.clod {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.clod { QuotaObservationContext }
    "server/src/providers/openai-compat" --> server.src.providers.clod { OpenAICompatProvider }
    server.src.lib.content --> server.src.providers.meldport { contentToString }
    server.src.providers.base --> server.src.providers.meldport {
        CompletionOptions,
        ProviderFetchOptions,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> server.src.providers.meldport { OpenAICompatProvider }
    "server/src/services/provider-quota" --> server.src.providers.meldport {
        QuotaObservationContext,
    }
    server.src.providers.base --> server.src.providers.rime { BaseProvider, KeyValidationResult }
    server.src.providers.base --> "server/src/providers/voice-gateways" {
        BaseProvider,
        KeyValidationResult,
    }
    server.src.providers.base --> server.src.providers.freetts { BaseProvider, KeyValidationResult }
    server.src.providers.base --> server.src.providers.blaze {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.blaze { QuotaObservationContext }
    "server/src/providers/openai-compat" --> server.src.providers.blaze { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.lucidity {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.lucidity {
        QuotaObservationContext,
    }
    "server/src/providers/openai-compat" --> server.src.providers.lucidity { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.airforce {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.airforce {
        QuotaObservationContext,
    }
    "server/src/providers/openai-compat" --> server.src.providers.airforce { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.dreamprompting {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.dreamprompting {
        QuotaObservationContext,
    }
    "server/src/providers/openai-compat" --> server.src.providers.dreamprompting {
        OpenAICompatProvider,
    }
    server.src.providers.base --> server.src.providers.waterfall {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.waterfall {
        QuotaObservationContext,
    }
    "server/src/providers/openai-compat" --> server.src.providers.waterfall { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.logfare {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.logfare {
        QuotaObservationContext,
    }
    "server/src/providers/openai-compat" --> server.src.providers.logfare { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.onomeo {
        CompletionOptions,
        KeyValidationResult,
        providerHttpError,
    }
    "server/src/services/provider-quota" --> server.src.providers.onomeo { QuotaObservationContext }
    "server/src/providers/openai-compat" --> server.src.providers.onomeo { OpenAICompatProvider }
    server.src.providers.base --> server.src.providers.iteracompute { KeyValidationResult }
    "server/src/providers/openai-compat" --> server.src.providers.iteracompute {
        OpenAICompatProvider,
    }
    server.src.db.index --> "server/src/__tests__/db/init-db-encryption.test";
    server.src.lib.crypto --> "server/src/__tests__/db/init-db-encryption.test";
    server.src.db.index --> "server/src/__tests__/db/init-db-options.test";
    server.src.db.index --> "server/src/__tests__/db/intelligence-tiers.test" { getDb, initDb }
    "server/src/db/migrations/20260802_000001_custom_endpoint_host_labels" --> "server/src/__tests__/db/migrate/custom-endpoint-host-labels.test" {
        down,
        up,
    }
    server.src.db.index --> "server/src/__tests__/db/migrate/custom-media-identity.test" {
        getDb,
        initDb,
    }
    "server/src/db/migrations/20261028_000001_custom_media_endpoint_identity" --> "server/src/__tests__/db/migrate/custom-media-identity.test" {
        down,
        up,
    }
    "server/src/db/migrations/20260819_000001_custom_model_tombstones" --> "server/src/__tests__/db/migrate/custom-model-tombstones.test" {
        down,
        up,
    }
    "server/src/db/migrations/20260706_000002_custom_model_tool_support" --> "server/src/__tests__/db/migrate/custom-model-tool-support.test" {
        down,
        up,
    }
    server.src.db.migrate.runner --> "server/src/__tests__/db/migrate/endpoint-identity.test" {
        runMigrations,
    }
    "server/src/db/migrations/20260101_000000_legacy_baseline" --> "server/src/__tests__/db/migrate/endpoint-identity.test" {
        up,
    }
    "server/src/db/migrations/20260729_000001_custom_model_endpoint_identity" --> "server/src/__tests__/db/migrate/endpoint-identity.test" {
        down,
        up,
    }
    server.src.db.migrate.runner --> "server/src/__tests__/db/migrate/legacy-baseline-rerun.test" {
        runMigrations,
    }
    server.src.db.migrate.defaults --> "server/src/__tests__/db/migrate/legacy-baseline-rerun.test" {
        DEFAULT_MIGRATIONS,
    }
    "server/src/db/migrations/20260101_000000_legacy_baseline" --> "server/src/__tests__/db/migrate/legacy-baseline-rerun.test" {
        up,
    }
    "server/src/db/migrations/20261111_000001_model_monthly_usage" --> "server/src/__tests__/db/migrate/model-monthly-usage.test" {
        down,
        up,
    }
    "server/src/db/migrations/20260101_000000_legacy_baseline" --> "server/src/__tests__/db/migrate/model-source-provenance.test" {
        up,
    }
    "server/src/db/migrations/20260726_000003_model_source_provenance" --> "server/src/__tests__/db/migrate/model-source-provenance.test" {
        down,
        up,
    }
    server.src.db.migrate.defaults --> "server/src/__tests__/db/migrate/registry-drift.test" {
        DEFAULT_MIGRATIONS,
    }
    server.src.db.migrate.runner --> "server/src/__tests__/db/migrate/remove-auray-provider.test" {
        runMigrations,
    }
    "server/src/db/migrations/20261019_000001_remove_auray_provider" --> "server/src/__tests__/db/migrate/remove-auray-provider.test" {
        down,
        up,
    }
    server.src.db.migrate.runner --> "server/src/__tests__/db/migrate/remove-github-provider.test" {
        runMigrations,
    }
    "server/src/db/migrations/20261017_000002_remove_github_provider" --> "server/src/__tests__/db/migrate/remove-github-provider.test" {
        down,
        up,
    }
    "server/src/db/migrations/20261017_233153_request_failure_attribution" --> "server/src/__tests__/db/migrate/request-failure-attribution.test" {
        down,
        up,
    }
    server.src.db.index --> "server/src/__tests__/db/migrate/roundtrip.test" { connectDb }
    server.src.db.migrate.runner --> "server/src/__tests__/db/migrate/roundtrip.test" {
        getMigrationStatuses,
        runMigrations,
    }
    "server/src/db/migrations/20260101_000000_legacy_baseline" --> "server/src/__tests__/db/migrate/roundtrip.test" {
        up,
    }
    server.src.db.migrate.runner --> "server/src/__tests__/db/migrate/runner.test" { runMigrations }
    "server/src/db/migrations/20260101_000000_legacy_baseline" --> "server/src/__tests__/db/migrate/unified-key-output.test" {
        up,
    }
    server.src.db.index --> "server/src/__tests__/db/node-sqlite.test" {
        connectDb,
        defaultDbFactory,
    }
    "server/src/db/node-sqlite" --> "server/src/__tests__/db/node-sqlite.test" { nodeSqliteFactory }
    server.src.db.migrate.runner --> "server/src/__tests__/db/node-sqlite.test" {
        runMigrationsSync,
    }
    server.src.db.types --> "server/src/__tests__/db/node-sqlite.test" { Db }
    server.src.db.index --> "server/src/__tests__/db/quota-snapshot-freshness.test" {
        getDb,
        initDb,
    }
    "server/src/db/migrations/20260915_000001_quota_snapshot_freshness" --> "server/src/__tests__/db/quota-snapshot-freshness.test" {
        down,
        up,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/db/quota-snapshot-freshness.test" {
        recordQuotaObservation,
    }
    server.src.db.index --> "server/src/__tests__/db/synchronous-pragma.test" { connectDb }
    server.src.db.types --> "server/src/__tests__/db/synchronous-pragma.test" { Db }
    server.src.app --> "server/src/__tests__/integration/full-flow.test" { createApp }
    server.src.db.index --> "server/src/__tests__/integration/full-flow.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/integration/full-flow.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.routes.keys --> server.src.app { keysRouter }
    "server/src/routes/client-profiles" --> server.src.app { clientProfilesRouter }
    server.src.routes.conversations --> server.src.app { conversationsRouter }
    server.src.routes.logs --> server.src.app { logsRouter }
    server.src.routes.models --> server.src.app { modelsRouter }
    server.src.routes.proxy --> server.src.app { proxyRouter }
    server.src.routes.responses --> server.src.app { responsesRouter }
    server.src.routes.anthropic --> server.src.app { anthropicRouter }
    server.src.routes.fallback --> server.src.app { fallbackRouter }
    server.src.routes.profiles --> server.src.app { profilesRouter }
    server.src.routes.embeddings --> server.src.app { embeddingsRouter }
    server.src.routes.media --> server.src.app { mediaRouter }
    server.src.routes.search --> server.src.app { searchRouter }
    server.src.routes.decisions --> server.src.app { decisionsRouter }
    server.src.routes.analytics --> server.src.app { analyticsRouter }
    server.src.routes.health --> server.src.app { healthRouter }
    "server/src/routes/free-tier" --> server.src.app { freeTierRouter }
    server.src.routes.settings --> server.src.app { settingsRouter }
    server.src.routes.premium --> server.src.app { premiumRouter }
    server.src.routes.backups --> server.src.app { backupsRouter }
    server.src.routes.cache --> server.src.app { cacheRouter }
    server.src.routes.compression --> server.src.app { compressionRouter }
    server.src.routes.auth --> server.src.app { authRouter }
    server.src.routes.docs --> server.src.app { docsRouter }
    server.src.routes.mcp --> server.src.app { mcpRouter }
    server.src.routes.status --> server.src.app { providersRouter, statusRouter }
    server.src.routes.gemini --> server.src.app { geminiRouter }
    server.src.routes.ollama --> server.src.app { ollamaRouter }
    "server/src/routes/url-tokens" --> server.src.app { urlTokenRouter }
    server.src.routes.update --> server.src.app { updateRouter }
    server.src.routes.moderation --> server.src.app { moderationRouter }
    server.src.middleware.requireAuth --> server.src.app { requireAuth }
    "server/src/middleware/allowed-hosts" --> server.src.app { createHostGuard }
    server.src.middleware.rateLimit --> server.src.app {
        createAdminRateLimiter,
        createProxyRateLimiter,
    }
    server.src.middleware.errorHandler --> server.src.app { errorHandler }
    "server/src/middleware/doubled-v1" --> server.src.app { collapseDoubledV1Prefix }
    "server/src/lib/client-context" --> server.src.app { clientContextMiddleware }
    server.src.lib.config --> server.src.app { Config, loadConfig }
    server.src.providers.speechflow --> server.src.routes.keys { speechFlowCredentials }
    server.src.db.index --> server.src.routes.keys { getDb }
    server.src.providers.index --> server.src.routes.keys { getAllProviders, resolveProvider }
    "server/src/providers/openai-compat" --> server.src.routes.keys {
        OpenAICompatProvider,
        isAnonymousCredential,
    }
    "server/src/services/catalog-sync" --> server.src.routes.keys { getSyncState }
    server.src.lib.crypto --> server.src.routes.keys { decrypt, encrypt, maskKey }
    "server/src/lib/key-parser" --> server.src.routes.keys {
        parseKeysFromFile,
        stripJsoncComments,
        stripTrailingCommas,
    }
    "server/src/lib/url-guard" --> server.src.routes.keys { assessProviderUrl }
    "server/src/lib/budget-input" --> server.src.routes.keys { budgetInputSchema }
    server.src.services.ratelimit --> server.src.routes.keys {
        clearApinexCheckinCooldownsForKey,
        clearCooldownsForKey,
        getActiveCooldownsForKeys,
    }
    "server/src/services/key-budget" --> server.src.routes.keys {
        getMonthlyBudgetCaps,
        getMonthlyUsage,
        nextMonthResetAt,
    }
    "server/src/services/custom-endpoint" --> server.src.routes.keys {
        customEndpointKeyIds,
        endpointHasCredential,
        normalizeGroupLabel,
        resolveCustomEndpointKey,
        setCustomEndpointGroup,
        siblingEndpointKeyId,
    }
    "server/src/services/custom-model-register" --> server.src.routes.keys {
        registerCustomChatModels,
        registerCustomModels,
    }
    "server/src/services/custom-media-register" --> server.src.routes.keys {
        registerCustomMediaModel,
    }
    "server/src/lib/search-platforms" --> server.src.routes.keys { isSearchPlatform }
    "server/src/services/model-discovery" --> server.src.routes.keys {
        DiscoveredModelKind,
        ModelDiscoveryError,
        classifyModelId,
        discoverEndpointModels,
        probeEndpointModel,
    }
    server.src.services.embeddings --> server.src.routes.keys {
        probeEmbeddingDimensions,
        registerCustomEmbeddingModel,
    }
    "server/src/lib/endpoint-scope" --> server.src.routes.keys {
        endpointScopeForBaseUrl,
        normalizeBaseUrl,
    }
    "server/src/services/custom-model-tombstone" --> server.src.routes.keys {
        recordCustomModelTombstone,
    }
    "server/src/services/builtin-model-discovery" --> server.src.routes.keys {
        builtinDiscoveryEligibility,
        builtinDiscoveryMode,
        discoverBuiltinModels,
        ineligibleMessage,
        isBuiltinDiscoveryEligible,
        registerDiscoveredModels,
        registeredModelIds,
        triggerBuiltinModelDiscovery,
    }
    server.src.db.types --> server.src.routes.keys { Db }
    "server/src/lib/model-scope" --> server.src.routes.keys { parseModelScope }
    "server/src/lib/key-proxy" --> server.src.routes.keys {
        KEY_PROXY_URL_ERROR,
        KEY_PROXY_URL_MAX,
        decryptProxyUrl,
        encryptProxyUrl,
        isValidKeyProxyUrl,
        maskProxyUrl,
    }
    server.src.lib.loopback --> server.src.routes.keys { isLoopbackRequest }
    "server/src/services/keyless-defaults" --> server.src.routes.keys {
        availableKeylessProviders,
        dismissAvailableKeylessProviders,
        enableAvailableKeylessProviders,
    }
    server.src.lib.budget --> "server/src/lib/budget-input" {
        BUDGET_INPUT_ERROR,
        normalizeBudgetInput,
    }
    server.src.db.index ++> server.src.services.auth { getDb }
    server.src.lib.password ++> server.src.services.auth { hashPassword, verifyPassword }
    server.src.db.types --> "server/src/services/custom-media-register" { Db }
    "server/src/services/custom-endpoint" --> "server/src/services/custom-media-register" {
        customEndpointKeyIds,
    }
    "server/src/lib/endpoint-scope" --> "server/src/services/custom-media-register" {
        endpointScopeOfKey,
    }
    server.src.db.index ++> "server/src/routes/client-profiles" { getDb }
    server.src.lib.crypto ++> "server/src/routes/client-profiles" { decrypt, encrypt, maskKey }
    "server/src/lib/system-prompt" ++> "server/src/routes/client-profiles" {
        hashClientProfileKey,
        mintClientProfileKey,
    }
    server.src.db.index --> server.src.routes.conversations { getDb }
    "server/src/lib/server-logs" --> server.src.routes.logs {
        LOG_LEVELS,
        ServerLogEntry,
        ServerLogLevel,
        clearLogs,
        currentMaxId,
        levelCounts,
        queryLogs,
    }
    server.src.db.index --> server.src.routes.models { getDb }
    server.src.providers.index --> server.src.routes.models { getProvider, hasProvider }
    "server/src/lib/custom-provider-cleanup" --> server.src.routes.models {
        deleteUnusedCustomEndpointKey,
    }
    "server/src/lib/budget-input" --> server.src.routes.models { budgetInputSchema }
    "server/src/services/model-state" --> server.src.routes.models {
        ModelOverridePatch,
        clearCatalogModelTombstone,
        isCatalogManagedModel,
        overriddenFieldNames,
        recordCatalogModelTombstone,
        upsertModelOverrides,
    }
    server.src.services.fusion --> server.src.routes.models { pruneUnavailableSavedFusionConfig }
    "server/src/services/profile-models" --> server.src.routes.models {
        ensureModelInProfiles,
        getActiveProfileId,
    }
    "server/src/lib/endpoint-scope" --> server.src.routes.models {
        endpointScopeForBaseUrl,
        endpointScopeOfKey,
        qualifiedModelMemberId,
    }
    "server/src/services/custom-model-tombstone" --> server.src.routes.models {
        clearCustomModelTombstone,
        recordCustomModelTombstone,
    }
    "server/src/services/custom-model-seed" --> server.src.routes.models { customModelSeed }
    server.src.services.router --> server.src.routes.models {
        failureAttributionFor,
        routePinnedModel,
    }
    "server/src/lib/request-log" --> server.src.routes.models { logRequest }
    server.src.lib.proxy --> server.src.routes.models { withKeyProxy }
    "server/src/lib/error-redaction" --> server.src.routes.models { sanitizeProviderErrorMessage }
    server.src.services.ratelimit --> server.src.routes.models { recordRequest, recordTokens }
    "server/src/services/key-budget" --> server.src.routes.models { recordMonthlyUsage }
    server.src.lib.content --> server.src.routes.models { contentToString }
    server.src.services.router --> server.src.routes.responses {
        ChainRow,
        ResolvedChain,
        RouteResult,
        failureAttributionFor,
        hasEnabledToolsModel,
        hasEnabledVisionModel,
        resolveModelGroupCandidates,
        resolveRoutingChain,
        resolveStickyPreference,
        routeRequest,
        routingReserveTokens,
    }
    server.src.db.index --> server.src.routes.responses { getDb }
    "server/src/lib/system-prompt" --> server.src.routes.responses {
        prependSystemPrompt,
        resolveAuth,
    }
    "server/src/lib/system-date" --> server.src.routes.responses { maybeInjectSystemDate }
    "server/src/services/model-groups" --> server.src.routes.responses {
        getModelGroups,
        isUnifyEnabled,
        resolveRequestedIdForDispatch,
    }
    server.src.lib.content --> server.src.routes.responses {
        contentToString,
        estimateInputTokens,
        messageHasImage,
    }
    "server/src/lib/output-cap" --> server.src.routes.responses { routeOutputBudget }
    "server/src/lib/task-type" --> server.src.routes.responses { resolveTaskType }
    "server/src/lib/image-normalize" --> server.src.routes.responses { normalizeMessageImages }
    "server/src/lib/tool-args" --> server.src.routes.responses {
        repairToolArguments,
        toolSchemaMap,
    }
    "server/src/lib/tool-validate" --> server.src.routes.responses {
        invalidToolArgumentsError,
        invalidToolCallReasons,
        isToolArgumentValidationEnabled,
    }
    "server/src/lib/tool-call-rescue" --> server.src.routes.responses {
        containsDialectMarker,
        couldBecomeDialectMarker,
        rescueInlineToolCalls,
        startsWithDialectMarker,
    }
    server.src.routes.proxy --> server.src.routes.responses {
        completionReasoningText,
        extractApiToken,
        getRequestGroupId,
        getStickyModel,
        logRequest,
        sessionIdentityMessages,
        setStickyModel,
        streamReasoningText,
        traceRouteEvent,
    }
    "server/src/lib/fallback-loop" --> server.src.routes.responses {
        AttemptRecord,
        exhaustionErrorPayload,
        fallbackRoutingTokens,
        newFallbackState,
        recordUpstreamSuccess,
        runFallbackLoop,
        setExhaustionHeaders,
        setFallbackHeaders,
    }
    "server/src/lib/header-value" --> server.src.routes.responses {
        routedViaValue,
        safeHeaderValue,
    }
    "server/src/lib/stream-keepalive" --> server.src.routes.responses {
        startStreamKeepalive,
        streamKeepaliveMs,
    }
    server.src.lib.guardrails --> server.src.routes.responses {
        applyTokenBudget,
        tokenBudgetMessage,
    }
    "server/src/lib/sampling-params" --> server.src.routes.responses {
        ResponseFormat,
        pickSamplingParams,
        samplingParamSchemaFields,
    }
    "server/src/lib/structured-output" --> server.src.routes.responses { enforceJsonContent }
    "server/src/lib/error-redaction" --> server.src.routes.responses {
        sanitizeProviderErrorMessage,
    }
    "server/src/lib/error-classify" --> server.src.routes.responses {
        isClientAbortError,
        isUpstreamClassificationOutput,
        newClientAbortError,
        newHedgeAbortError,
    }
    "server/src/services/provider-quota" --> server.src.routes.responses {
        QuotaObservationContext,
        inferQuotaPoolKey,
    }
    server.src.services.compression.pipeline --> server.src.routes.responses {
        compressRequest,
        formatCompressionHeader,
    }
    "server/src/lib/responses-web-search" --> server.src.routes.responses {
        maybeServeResponsesWebSearch,
        webSearchCallToText,
    }
    server.src.services.fusion --> server.src.routes.responses {
        FUSION_MODEL_ID,
        FusionError,
        FusionResult,
        fusionConfigSchema,
        isFusionModel,
        runFusion,
    }
    "server/src/services/routing-decision" --> server.src.routes.responses {
        applyDecisionRouting,
        routingStrategyHeader,
    }
    "server/src/services/anthropic-map" --> server.src.routes.responses { resolveListedClaudeAlias }
    "server/src/lib/web-search-tool" --> "server/src/lib/responses-web-search" {
        DomainFilter,
        WEB_SEARCH_FUNCTION_DESCRIPTION,
        WEB_SEARCH_FUNCTION_PARAMETERS,
        WEB_SEARCH_TOOL_NAME,
        WebSearchOutcome,
        copyCapturedHeaders,
        formatOutcomeForModel,
        hasSearchCapability,
        invokeHandlerCaptured,
        newWebSearchCallId,
        performWebSearch,
        resolveMaxSearches,
    }
    server.src.services.search --> "server/src/lib/web-search-tool" {
        SearchError,
        runSearch,
        searchAvailable,
    }
    server.src.services.router --> server.src.routes.anthropic {
        ChainRow,
        ResolvedChain,
        RouteResult,
        failureAttributionFor,
        resolveModelGroupCandidates,
        resolveRoutingChain,
        resolveStickyPreference,
        routeRequest,
        routingReserveTokens,
    }
    server.src.db.index --> server.src.routes.anthropic { getSetting }
    "server/src/lib/system-prompt" --> server.src.routes.anthropic {
        ResolvedAuth,
        prependSystemPrompt,
        resolveAuth,
    }
    "server/src/lib/system-date" --> server.src.routes.anthropic { maybeInjectSystemDate }
    server.src.lib.content --> server.src.routes.anthropic { contentToString, estimateInputTokens }
    "server/src/lib/output-cap" --> server.src.routes.anthropic { routeOutputBudget }
    "server/src/lib/task-type" --> server.src.routes.anthropic { resolveTaskType }
    "server/src/lib/tool-args" --> server.src.routes.anthropic {
        repairToolArguments,
        toolSchemaMap,
    }
    "server/src/lib/tool-validate" --> server.src.routes.anthropic {
        invalidToolArgumentsError,
        invalidToolCallReasons,
        isToolArgumentValidationEnabled,
    }
    "server/src/lib/tool-call-rescue" --> server.src.routes.anthropic {
        containsDialectMarker,
        couldBecomeDialectMarker,
        rescueInlineToolCalls,
        startsWithDialectMarker,
    }
    "server/src/lib/error-redaction" --> server.src.routes.anthropic {
        sanitizeProviderErrorMessage,
    }
    "server/src/lib/anthropic-documents" --> server.src.routes.anthropic {
        convertDocumentBlock,
        documentRejectionMessage,
    }
    "server/src/lib/error-classify" --> server.src.routes.anthropic {
        isClientAbortError,
        isUpstreamClassificationOutput,
        newClientAbortError,
        newHedgeAbortError,
    }
    "server/src/lib/request-log" --> server.src.routes.anthropic { logRequest }
    server.src.routes.proxy --> server.src.routes.anthropic {
        extractApiToken,
        getStickyModel,
        providerSafeStop,
        sessionIdentityMessages,
        setStickyModel,
    }
    "server/src/lib/fallback-loop" --> server.src.routes.anthropic {
        AttemptRecord,
        ExhaustionBody,
        FallbackState,
        REASONING_HOLD_MAX_MS,
        fallbackRoutingTokens,
        newFallbackState,
        recordUpstreamSuccess,
        runFallbackLoop,
        setExhaustionHeaders,
        setFallbackHeaders,
    }
    "server/src/lib/header-value" --> server.src.routes.anthropic { routedViaValue }
    "server/src/lib/stream-keepalive" --> server.src.routes.anthropic {
        startStreamKeepalive,
        streamKeepaliveMs,
    }
    server.src.lib.guardrails --> server.src.routes.anthropic {
        applyTokenBudget,
        tokenBudgetMessage,
    }
    "server/src/services/anthropic-map" --> server.src.routes.anthropic {
        claudeFamilyDiscoveryEntries,
        resolveAnthropicModel,
    }
    "server/src/services/model-groups" --> server.src.routes.anthropic {
        getModelGroups,
        isUnifyEnabled,
        resolveRequestedIdForDispatch,
    }
    "server/src/lib/sampling-params" --> server.src.routes.anthropic { ReasoningEffort }
    "server/src/services/model-listing" --> server.src.routes.anthropic { buildModelListing }
    server.src.services.compression.pipeline --> server.src.routes.anthropic {
        compressRequest,
        formatCompressionHeader,
    }
    "server/src/lib/image-normalize" --> server.src.routes.anthropic { normalizeMessageImages }
    "server/src/lib/anthropic-web-search" --> server.src.routes.anthropic {
        maybeServeAnthropicWebSearch,
        serverToolUseToText,
        webSearchResultToText,
    }
    "server/src/services/routing-decision" --> server.src.routes.anthropic {
        applyDecisionRouting,
        routingStrategyHeader,
    }
    "server/src/lib/web-search-tool" --> "server/src/lib/anthropic-web-search" {
        DomainFilter,
        WEB_SEARCH_FUNCTION_DESCRIPTION,
        WEB_SEARCH_FUNCTION_PARAMETERS,
        WEB_SEARCH_TOOL_NAME,
        WebSearchOutcome,
        copyCapturedHeaders,
        decodeHitContent,
        encodeHitContent,
        formatOutcomeForModel,
        hasSearchCapability,
        invokeHandlerCaptured,
        newServerToolUseId,
        performWebSearch,
        resolveMaxSearches,
    }
    server.src.db.index --> server.src.routes.fallback { getDb }
    server.src.services.router --> server.src.routes.fallback {
        getActiveRoutingWeights,
        getAllPenalties,
        getExploreEnabled,
        getKeySelectionStrategy,
        getPeakHoursConfig,
        getRoutingScores,
        getRoutingStrategy,
        setCustomWeights,
        setExploreEnabled,
        setKeySelectionStrategy,
        setPeakHoursConfig,
        setRoutingStrategy,
    }
    server.src.services.scoring --> server.src.routes.fallback {
        BANDIT_PRESETS,
        RoutingStrategy,
        isValidTimezone,
    }
    server.src.lib.budget --> server.src.routes.fallback {
        effectiveMonthlyBudget,
        monthlyBudgetScore,
        parseBudget,
    }
    "server/src/services/model-groups" --> server.src.routes.fallback { getModelGroups }
    "server/src/services/penalty-inspector" --> server.src.routes.fallback {
        clearRouterPressure,
        getPenaltyInspector,
    }
    server.src.services.ratelimit --> server.src.routes.fallback {
        MAX_COOLDOWN_CEILING_MS,
        MIN_COOLDOWN_CEILING_MS,
        getCooldownCeilingMs,
        setCooldownCeilingMs,
    }
    "server/src/services/profile-models" --> server.src.routes.fallback { getActiveProfileId }
    "server/src/lib/endpoint-scope" --> server.src.routes.fallback {
        endpointScopeForBaseUrl,
        qualifiedModelMemberId,
    }
    "server/src/services/model-state" --> server.src.routes.fallback { overriddenFieldNames }
    "server/src/lib/model-scope" --> server.src.routes.fallback { parseModelScope, scopeAllows }
    "server/src/services/quota-outlook" --> server.src.routes.fallback { getQuotaOutlook }
    "server/src/services/routing-decision" --> server.src.routes.fallback {
        getDecisionRoutingStatus,
        setDecisionRoutingSettings,
    }
    server.src.db.index --> "server/src/services/penalty-inspector" { getDb }
    server.src.services.router --> "server/src/services/penalty-inspector" {
        clearAllPenalties,
        getAllPenalties,
    }
    server.src.services.scoring --> "server/src/services/penalty-inspector" { rateLimitFactor }
    server.src.services.ratelimit --> "server/src/services/penalty-inspector" { clearAllCooldowns }
    "server/src/lib/fallback-loop" --> "server/src/services/penalty-inspector" {
        clearModelFailureWindows,
    }
    "server/src/services/provider-quota" --> "server/src/services/quota-outlook" {
        QuotaObservationView,
        getQuotaStateForKeys,
    }
    "server/src/services/quota-forecast" --> "server/src/services/quota-outlook" {
        MIN_FORECAST_REQUESTS,
        RATE_OBSERVATION_WINDOW_MINUTES,
        estimateExhaustionAt,
        getRecentQuotaActivity,
    }
    "server/src/services/provider-quota" --> "server/src/services/quota-forecast" {
        QuotaObservationView,
        getQuotaStateForKeys,
        inferPoolForPlatform,
    }
    server.src.db.index --> "server/src/services/quota-forecast" { getDb }
    server.src.db.index --> server.src.routes.profiles { getDb }
    server.src.lib.budget --> server.src.routes.profiles { monthlyBudgetScore }
    server.src.db.index --> server.src.routes.embeddings { getDb, setSetting }
    server.src.lib.crypto --> server.src.routes.embeddings { decrypt, maskKey }
    "server/src/lib/custom-provider-cleanup" --> server.src.routes.embeddings {
        deleteUnusedCustomEndpointKey,
    }
    "server/src/services/custom-endpoint" --> server.src.routes.embeddings {
        resolveCustomEndpointKey,
    }
    server.src.services.embeddings --> server.src.routes.embeddings {
        EmbeddingModelRow,
        EmbeddingsError,
        asEmbeddingInputType,
        getDefaultFamily,
        listEmbeddingModels,
        probeEmbeddingDimensions,
        registerCustomEmbeddingModel,
    }
    server.src.db.index --> server.src.routes.media { getDb }
    server.src.lib.crypto --> server.src.routes.media { maskKey }
    "server/src/lib/custom-provider-cleanup" --> server.src.routes.media {
        deleteUnusedCustomEndpointKey,
    }
    "server/src/services/custom-endpoint" --> server.src.routes.media { resolveCustomEndpointKey }
    "server/src/services/custom-media-register" --> server.src.routes.media {
        registerCustomMediaModel,
    }
    server.src.services.media --> server.src.routes.media { listAllMediaModels }
    server.src.services.search --> server.src.routes.search {
        SearchError,
        listSearchEngines,
        runSearch,
        searchStatus,
        updateSearchEngine,
    }
    "server/src/services/catalog-sync" --> server.src.routes.search { getSyncState }
    server.src.services.decision --> server.src.routes.decisions {
        DecisionError,
        listDecisionModels,
        runDecision,
        setDecisionModelEnabled,
    }
    server.src.db.index --> server.src.routes.analytics { getDb }
    "server/src/db/model-pricing" --> server.src.routes.analytics {
        FALLBACK_INPUT_PER_M,
        FALLBACK_OUTPUT_PER_M,
    }
    "server/src/lib/provider-identity" --> server.src.routes.analytics {
        providerDisplayName,
        providerIdFor,
    }
    "server/src/lib/endpoint-scope" --> server.src.routes.analytics { normalizeBaseUrl }
    server.src.services.search --> server.src.routes.analytics {
        SearchAnalyticsRange,
        searchAnalytics,
    }
    server.src.db.index --> server.src.routes.health { getDb, isKeyStoreDecryptable }
    server.src.services.health --> server.src.routes.health {
        checkAllKeys,
        checkKeyHealth,
        pollKeyQuota,
        supportsQuotaPolling,
    }
    server.src.services.degradation --> server.src.routes.health { getDegradationStatus }
    "server/src/services/model-probe" --> server.src.routes.health { runModelProbePass }
    server.src.providers.index --> server.src.routes.health { hasProvider, resolveProvider }
    "server/src/services/provider-quota" --> server.src.routes.health { getQuotaStateForKeys }
    server.src.lib.scheduler --> "server/src/services/model-probe" { Scheduler }
    server.src.db.types --> "server/src/services/model-probe" { Db }
    server.src.db.index --> "server/src/services/model-probe" { getDb }
    server.src.providers.index --> "server/src/services/model-probe" { resolveProvider }
    server.src.lib.crypto --> "server/src/services/model-probe" { decrypt }
    "server/src/lib/key-proxy" --> "server/src/services/model-probe" { decryptProxyUrl }
    server.src.lib.proxy --> "server/src/services/model-probe" { withKeyProxy }
    "server/src/lib/error-redaction" --> "server/src/services/model-probe" {
        sanitizeProviderErrorMessage,
    }
    "server/src/lib/server-logs" --> "server/src/services/model-probe" { providerLog }
    "server/src/services/provider-quota" --> "server/src/services/model-probe" { inferQuotaPoolKey }
    server.src.db.index --> "server/src/routes/free-tier" { getDb }
    server.src.lib.budget --> "server/src/routes/free-tier" { parseBudget }
    "server/src/services/profile-models" --> "server/src/routes/free-tier" { getActiveProfileId }
    "server/src/services/provider-quota" --> "server/src/routes/free-tier" {
        getQuotaStateForKeys,
        inferQuotaPoolKey,
    }
    server.src.db.index --> server.src.routes.settings {
        getDb,
        getSetting,
        getUnifiedApiKey,
        regenerateUnifiedKey,
        setSetting,
    }
    server.src.lib.proxy --> server.src.routes.settings {
        DEFAULT_PROXY_PROBE_TARGET,
        PROXY_MODES,
        PROXY_SCHEMES,
        applyFetchRelayToken,
        applyProxyBypass,
        applyProxyEnabled,
        applyProxyMode,
        applyProxyUrl,
        encodeFetchRelayToken,
        fetchRelayUrlError,
        getFetchRelayToken,
        getProxyBypassPlatforms,
        getProxyMode,
        getProxyUrl,
        isProxyActive,
        isProxyEnabled,
        probeProxyUrl,
    }
    server.src.providers.index --> server.src.routes.settings { getProvider }
    server.src.services.fusion --> server.src.routes.settings {
        getFusionMaxK,
        getSavedFusionConfig,
        savedFusionConfigSchema,
        setSavedFusionConfig,
    }
    "server/src/services/model-groups" --> server.src.routes.settings {
        getUnifyOverrides,
        isUnifyEnabled,
        setUnifyEnabled,
        setUnifyOverrides,
        unifyOverridesSchema,
    }
    "server/src/services/anthropic-map" --> server.src.routes.settings {
        getClaudeModelMap,
        setClaudeModelMap,
    }
    "server/src/services/gemini-map" --> server.src.routes.settings {
        getGeminiModelMap,
        setGeminiModelMap,
    }
    server.src.routes.ollama --> server.src.routes.settings { getOllamaEmulationMode }
    "server/src/lib/min-context-window" --> server.src.routes.settings {
        MIN_CONTEXT_WINDOW_PRESETS,
        MIN_CONTEXT_WINDOW_SETTING,
    }
    server.src.routes.update --> server.src.routes.settings {
        UPDATE_CHECK_SETTING,
        isAutoUpdateCheckEnabled,
    }
    "server/src/services/url-tokens" --> server.src.routes.settings {
        listUrlTokens,
        mintUrlToken,
        revokeUrlToken,
    }
    server.src.lib.guardrails --> server.src.routes.settings {
        MAX_CONSECUTIVE_UPSTREAM_FAILS_SETTING,
        REQUEST_MAX_TOKENS_BUDGET_SETTING,
        getMaxConsecutiveUpstreamFails,
        getRequestMaxTokensBudget,
    }
    server.src.services.compression.config --> server.src.routes.settings {
        compressionUpdateSchema,
        getCompressionConfig,
        setCompressionConfig,
    }
    server.src.services.router --> server.src.routes.settings {
        getHeadroomThresholds,
        getMinReliabilityFloor,
        getTaskWeightShare,
        isProviderMomentAttributionEnabled,
        setHeadroomThresholds,
        setMinReliabilityFloor,
        setProviderMomentAttribution,
        setTaskWeightShare,
    }
    server.src.routes.mcp --> server.src.routes.settings { MCP_ENABLED_SETTING, isMcpServerEnabled }
    "server/src/lib/app-version" --> server.src.routes.settings { getAppVersion }
    "server/src/lib/sampling-params" --> server.src.routes.settings {
        UNIFIED_MAX_TOKENS_AUTO,
        UNIFIED_MAX_TOKENS_SETTING,
        unifiedMaxTokensCap,
    }
    "server/src/lib/system-date" --> server.src.routes.settings {
        SYSTEM_DATE_MODES,
        getSystemDateMode,
        setSystemDateMode,
    }
    server.src.db.index --> "server/src/services/gemini-map" { getDb, getSetting, setSetting }
    server.src.lib.loopback --> server.src.routes.ollama { isLoopbackRequest }
    server.src.db.index --> server.src.routes.ollama { getSetting, getUnifiedApiKey }
    "server/src/services/model-listing" --> server.src.routes.ollama { buildModelListing }
    server.src.routes.proxy --> server.src.routes.ollama { extractApiToken, timingSafeStringEqual }
    "server/src/lib/system-date" --> server.src.routes.ollama { maybeInjectSystemDate }
    "server/src/lib/inbound-chat" --> server.src.routes.ollama {
        InboundChatResult,
        InboundChatWire,
        runInboundChat,
    }
    server.src.services.embeddings --> server.src.routes.ollama {
        EmbeddingsError,
        embeddingsRetryAfterSec,
        runEmbeddings,
    }
    server.src.db.index --> server.src.routes.update { getSetting }
    "server/src/lib/app-version" --> server.src.routes.update { getAppVersion }
    server.src.db.index --> "server/src/services/url-tokens" { getDb, getUnifiedApiKey }
    server.src.routes.proxy --> "server/src/services/url-tokens" { timingSafeStringEqual }
    server.src.db.index --> server.src.routes.mcp { getDb, getSetting, getUnifiedApiKey }
    server.src.routes.proxy --> server.src.routes.mcp { extractApiToken, timingSafeStringEqual }
    server.src.services.search --> server.src.routes.mcp { runSearch, searchStatus }
    "server/src/services/model-listing" --> server.src.routes.mcp { buildModelListing }
    "server/src/lib/sampling-params" --> server.src.routes.mcp { supportedParametersForPlatforms }
    server.src.services.router --> server.src.routes.mcp {
        getRoutingScores,
        getRoutingStrategy,
        setRoutingStrategy,
    }
    server.src.services.scoring --> server.src.routes.mcp { RoutingStrategy }
    server.src.services.cache --> server.src.routes.mcp { clearCache, getCacheStats }
    server.src.services.compression.stats --> server.src.routes.mcp { getCompressionStats }
    "server/src/services/quota-outlook" --> server.src.routes.mcp { getQuotaOutlook }
    "server/src/lib/error-redaction" --> server.src.routes.mcp { sanitizeProviderErrorMessage }
    server.src.db.index --> server.src.routes.premium { getDb, getSetting }
    "server/src/services/catalog-sync" --> server.src.routes.premium {
        SETTING_LICENSE_KEY,
        SETTING_LICENSE_STATUS,
        catalogBaseUrl,
        catalogFetch,
        getCachedLicenseStatus,
        getSyncState,
        refreshLicenseStatus,
        storeActivatedLicense,
        syncCatalog,
        validateLicenseKey,
    }
    server.src.db.index --> server.src.routes.backups { getDb }
    server.src.services.backups --> server.src.routes.backups {
        BackupSchedule,
        assertBackupPathAllowed,
        createBackup,
        deleteBackup,
        getBackupFile,
        listBackups,
        listTables,
        readBackupSchedule,
        restoreBackup,
        writeBackupSchedule,
    }
    server.src.db.index --> server.src.services.backups {
        getDb,
        getDefaultDbPath,
        getSetting,
        setSetting,
    }
    server.src.db.types --> server.src.services.backups { Db }
    server.src.lib.crypto --> server.src.services.backups { encryptionKeyFingerprint }
    "server/src/lib/file-permissions" --> server.src.services.backups {
        restrictDirToOwner,
        restrictToOwner,
    }
    server.src.lib.scheduler --> server.src.services.backups { Scheduler }
    server.src.db.index --> server.src.routes.cache { setSetting }
    server.src.services.cache --> server.src.routes.cache {
        CACHE_ENABLED_SETTING,
        cacheMaxEntries,
        cacheMaxTemperature,
        cacheTtlMs,
        clearCache,
        getCacheStats,
        isCacheEnabled,
    }
    server.src.services.compression.types --> server.src.routes.compression {
        COMPRESSION_MODES,
        CompressionMode,
    }
    server.src.services.compression.pipeline --> server.src.routes.compression { compressRequest }
    server.src.services.compression.config --> server.src.routes.compression {
        getCompressionConfig,
    }
    server.src.services.compression.stats --> server.src.routes.compression { getCompressionStats }
    server.src.services.oidc --> server.src.routes.auth {
        OIDC_TX_COOKIE_NAME,
        OidcFlowError,
        completeOidcCallback,
        consumeOidcExchangeCode,
        getOidcEndSessionUrl,
        getPublicOidcStatus,
        isPasswordLoginDisabled,
        startOidcAuthorization,
    }
    "server/src/lib/setup-code" --> server.src.routes.auth { clearSetupCode, setupCodeMatches }
    server.src.lib.loopback --> server.src.routes.auth { isLoopbackRequest }
    "server/src/lib/reset-code" --> server.src.routes.auth {
        clearResetCode,
        generateResetCode,
        resetCodeMatches,
    }
    server.src.db.index --> server.src.services.oidc { getDb }
    "server/src/lib/setup-code" --> server.src.services.oidc { clearSetupCode }
    "server/src/lib/one-time-code" ++> "server/src/lib/setup-code" { createOneTimeCode }
    "server/src/lib/one-time-code" ++> "server/src/lib/reset-code" { createOneTimeCode }
    server.src.docs.openapi --> server.src.routes.docs { openapiSpec }
    "server/src/docs/docs-page" --> server.src.routes.docs { DOCS_HTML }
    server.src.db.index --> server.src.routes.status {
        getDb,
        getUnifiedApiKey,
        isKeyStoreDecryptable,
    }
    server.src.lib.crypto --> server.src.routes.status { isEncryptionKeyInitialized }
    server.src.routes.proxy --> server.src.routes.status { extractApiToken, timingSafeStringEqual }
    server.src.providers.index --> server.src.routes.status { getProvider }
    server.src.services.ratelimit --> server.src.routes.status { getSoonestCooldownExpiry }
    "server/src/services/provider-quota" --> server.src.routes.status { getQuotaStateForKeys }
    "server/src/services/quota-forecast" --> server.src.routes.status {
        LOW_BALANCE_ABSOLUTE,
        LOW_BALANCE_ABSOLUTE_MIN_LIMIT,
        LOW_BALANCE_THRESHOLD,
        getQuotaForecast,
    }
    server.src.docs.openapi --> server.src.routes.status { openapiSpec }
    "server/src/services/model-listing" --> server.src.routes.gemini {
        NormalizedModel,
        buildModelListing,
    }
    server.src.routes.proxy --> server.src.routes.gemini { extractApiToken }
    "server/src/lib/system-prompt" --> server.src.routes.gemini {
        ResolvedAuth,
        prependSystemPrompt,
        resolveAuth,
    }
    "server/src/lib/system-date" --> server.src.routes.gemini { maybeInjectSystemDate }
    "server/src/lib/inbound-chat" --> server.src.routes.gemini { InboundChatWire, runInboundChat }
    "server/src/lib/gemini-wire" --> server.src.routes.gemini {
        GeminiInboundRequest,
        effortFromGeminiThinking,
        estimateGeminiTokens,
        geminiContentsToMessages,
        geminiFinishReason,
        geminiPartsFromResult,
        geminiResponseFormat,
        geminiResponseFromResult,
        geminiToolChoice,
        geminiToolsToChatTools,
    }
    "server/src/services/gemini-map" --> server.src.routes.gemini { resolveGeminiModel }
    server.src.db.index --> "server/src/routes/url-tokens" { getUnifiedApiKey }
    server.src.routes.ollama --> "server/src/routes/url-tokens" { ollamaRouter }
    server.src.routes.proxy --> "server/src/routes/url-tokens" { proxyRouter }
    server.src.routes.responses --> "server/src/routes/url-tokens" { responsesRouter }
    "server/src/services/url-tokens" --> "server/src/routes/url-tokens" { validateUrlToken }
    server.src.routes.proxy --> server.src.routes.moderation { extractApiToken }
    "server/src/lib/system-prompt" --> server.src.routes.moderation { resolveAuth }
    server.src.services.moderation --> server.src.routes.moderation {
        ModerationError,
        runModerations,
    }
    server.src.db.index --> server.src.services.moderation { getDb }
    "server/src/lib/client-context" --> server.src.services.moderation { getClientContext }
    server.src.lib.crypto --> server.src.services.moderation { decrypt }
    "server/src/lib/model-scope" --> server.src.services.moderation { parseModelScope, scopeAllows }
    server.src.lib.proxy --> server.src.services.moderation { proxyFetch }
    "server/src/services/key-budget" --> server.src.services.moderation {
        checkMonthlyBudget,
        secondsUntilNextMonth,
    }
    "server/src/services/budget-alerts" --> server.src.services.moderation { noteBudgetAlerts }
    server.src.services.health --> server.src.services.moderation { markKeyHealthyFromRequest }
    "server/src/lib/request-log" --> server.src.middleware.errorHandler { logRequest }
    "server/src/lib/anthropic-documents" --> "server/src/__tests__/lib/anthropic-documents.test" {
        convertDocumentBlock,
        documentRejectionMessage,
        fenceTag,
        labelTitle,
    }
    server.src.db.index --> "server/src/__tests__/lib/apinex-checkin-preservation.test" {
        getDb,
        initDb,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/apinex-checkin-preservation.test" {
        newFallbackState,
        recordRetryableFailure,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/apinex-checkin-preservation.test" {
        CooldownSource,
        clearAllCooldowns,
        clearApinexCheckinCooldownsForKey,
        getCooldownSource,
        getProbeableCooldowns,
        isOnCooldown,
        setCooldown,
    }
    server.src.services.router --> "server/src/__tests__/lib/apinex-checkin-preservation.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/apinex-checkin.test" { initDb }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/apinex-checkin.test" {
        cooldownDecisionForError,
        exhaustedRetryError,
        isApinexCheckinRequired,
        newFallbackState,
        recordRetryableFailure,
        routingExhaustionBody,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/apinex-checkin.test" {
        clearCooldownsForKey,
        getCooldownSource,
        setCooldown,
    }
    server.src.services.router --> "server/src/__tests__/lib/apinex-checkin.test" {
        RouteResult,
        getAllPenalties,
    }
    server.src.app --> "server/src/__tests__/lib/app-version.test" { createApp }
    server.src.db.index --> "server/src/__tests__/lib/app-version.test" { initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/lib/app-version.test" {
        mintDashboardToken,
    }
    "server/src/lib/app-version" --> "server/src/__tests__/lib/app-version.test" {
        getAppVersion,
        resetAppVersionCache,
    }
    server.src.lib.budget --> "server/src/__tests__/lib/budget.test" {
        effectiveMonthlyBudget,
        monthlyBudgetScore,
        normalizeBudgetInput,
        parseBudget,
    }
    "server/src/lib/client-classifier" --> "server/src/__tests__/lib/client-classifier.test" {
        classifyClientAgent,
    }
    "server/src/lib/client-context" --> "server/src/__tests__/lib/client-context.test" {
        clientContextMiddleware,
        getClientContext,
    }
    server.src.lib.config --> "server/src/__tests__/lib/config.test" { loadConfig }
    server.src.lib.content --> "server/src/__tests__/lib/content.test" {
        contentToString,
        estimateInputTokens,
        flattenMessageContent,
        messageHasImage,
        normalizeOutboundContent,
        sanitizeResponse,
        stripImagesFromMessages,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/crypto-init.test" {
        decrypt,
        encrypt,
        initEncryptionKey,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/crypto-keyfile.test" {
        decrypt,
        encrypt,
        initEncryptionKey,
    }
    server.src.__tests__.helpers.acl --> "server/src/__tests__/lib/crypto-keyfile.test" {
        aclEntries,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/crypto-selfcheck.test" {
        encrypt,
        initEncryptionKey,
        probeStoredSecrets,
    }
    server.src.db.index --> "server/src/__tests__/lib/crypto.test" { initDb }
    server.src.lib.crypto --> "server/src/__tests__/lib/crypto.test" { decrypt, encrypt, maskKey }
    "server/src/lib/db-backup" --> "server/src/__tests__/lib/db-backup.test" {
        _resetDbBackupStateForTesting,
        backupDbNow,
        parseHuggingFaceTarget,
        restoreDbBackupIfNeeded,
    }
    server.src.__tests__.helpers.acl --> "server/src/__tests__/lib/db-backup.test" { aclEntries }
    server.src.db.types --> "server/src/lib/db-backup" { Db }
    server.src.lib.scheduler --> "server/src/lib/db-backup" { Scheduler }
    server.src.db.index --> "server/src/lib/db-backup" { getDefaultDbPath }
    "server/src/lib/file-permissions" --> "server/src/lib/db-backup" { restrictToOwner }
    server.src.db.index --> "server/src/__tests__/lib/degraded-error.test" { initDb }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/degraded-error.test" {
        isProviderBadRequestError,
        isProviderDegradedError,
        isRetryableError,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/degraded-error.test" {
        classifyAttemptError,
        exhaustedRetryError,
    }
    "server/src/lib/endpoint-scope" --> "server/src/__tests__/lib/endpoint-scope.test" {
        endpointHandle,
        endpointRefMatches,
        endpointScopeForBaseUrl,
        modelStatsKey,
        normalizeBaseUrl,
        qualifiedModelMemberId,
    }
    "server/src/lib/env-drift" --> "server/src/__tests__/lib/env-drift.test" {
        compareEnvText,
        formatEnvDriftReport,
        parseEnvNames,
        warnOnEnvDrift,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/error-classify-provider-moment.test" {
        isProviderMomentFailure,
        newClientAbortError,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/error-classify-transport.test" {
        isRetryableError,
        isTransportError,
        newClientAbortError,
        newHedgeAbortError,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/error-code-boundaries.test" {
        isModelNotFoundError,
        isRetryableError,
    }
    "server/src/lib/error-redaction" --> "server/src/__tests__/lib/error-redaction.test" {
        sanitizeProviderErrorMessage,
        summarizeAttemptError,
    }
    server.src.db.index --> "server/src/__tests__/lib/exhaustion-statuses.test" { getDb, initDb }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/exhaustion-statuses.test" {
        AttemptErrorClass,
        AttemptRecord,
        FallbackHooks,
        classifyAttemptError,
        exhaustedRetryError,
        exhaustionErrorPayload,
        newFallbackState,
        routingExhaustionBody,
        runFallbackLoop,
        setExhaustionHeaders,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/exhaustion-statuses.test" {
        isContextTooLargeError,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/exhaustion-statuses.test" {
        setCooldown,
    }
    server.src.services.router --> "server/src/__tests__/lib/exhaustion-statuses.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-account-suspended.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/fallback-loop-account-suspended.test" {
        encrypt,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-account-suspended.test" {
        classifyAttemptError,
        cooldownDecisionForError,
        newFallbackState,
        recordRetryableFailure,
        resetModelFailureWindows,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/fallback-loop-account-suspended.test" {
        isAccountSuspendedError,
        isModelNotFoundError,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-account-suspended.test" {
        PAYMENT_REQUIRED_COOLDOWN_MS,
        clearCooldownsForKey,
        getActiveCooldownsForKeys,
        isOnCooldown,
        resetKeyLocalityCache,
        setCooldownCeilingMs,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-account-suspended.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-client-abort.test" {
        getDb,
        initDb,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-client-abort.test" {
        FallbackState,
        newFallbackState,
        runFallbackLoop,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/fallback-loop-client-abort.test" {
        isClientAbortError,
        isRetryableError,
        newClientAbortError,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-client-abort.test" {
        acquireLease,
        inFlightForKey,
        releaseLease,
        resetLeases,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-client-abort.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-groq-directional-tpm.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/fallback-loop-groq-directional-tpm.test" {
        encrypt,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-groq-directional-tpm.test" {
        newFallbackState,
        recordRetryableFailure,
        resetModelFailureWindows,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-groq-directional-tpm.test" {
        isOnCooldown,
        resetKeyLocalityCache,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-groq-directional-tpm.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-hedge.test" {
        getDb,
        initDb,
        setSetting,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-hedge.test" {
        ATTEMPT_SILENT_SETTING,
        DEFAULT_ATTEMPT_SILENT_MS,
        FallbackState,
        getAttemptSilentMs,
        newFallbackState,
        runFallbackLoop,
    }
    "server/src/lib/upstream-watch" --> "server/src/__tests__/lib/fallback-loop-hedge.test" {
        currentUpstreamWatch,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/fallback-loop-hedge.test" {
        isClientAbortError,
        isHedgeAbortError,
        isRetryableError,
        newHedgeAbortError,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-hedge.test" {
        acquireLease,
        releaseLease,
        resetLeases,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-hedge.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-issue-1230.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/fallback-loop-issue-1230.test" { encrypt }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-issue-1230.test" {
        FallbackState,
        newFallbackState,
        recordRetryableFailure,
        recordUpstreamSuccess,
        resetModelFailureWindows,
    }
    "server/src/lib/tool-capability" --> "server/src/__tests__/lib/fallback-loop-issue-1230.test" {
        TOOL_BENCH_MS,
        TOOL_REJECTION_LIMIT,
        TOOL_REJECTION_WINDOW_MS,
        isToolBenched,
        resetToolCapability,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-issue-1230.test" {
        clearCooldownsForKey,
        resetKeyLocalityCache,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-issue-1230.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-issue-1239.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/fallback-loop-issue-1239.test" { encrypt }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-issue-1239.test" {
        AttemptErrorClass,
        AttemptRecord,
        FallbackHooks,
        classifyAttemptError,
        cooldownDecisionForError,
        exhaustedRetryError,
        newFallbackState,
        recordRetryableFailure,
        resetModelFailureWindows,
        runFallbackLoop,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/fallback-loop-issue-1239.test" {
        isModelAccessForbiddenError,
        isModelNotFoundError,
        isProviderBadRequestError,
        isRetryableError,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-issue-1239.test" {
        clearCooldownsForKey,
        isOnCooldown,
        resetKeyLocalityCache,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-issue-1239.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-late-inband.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/fallback-loop-late-inband.test" { encrypt }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-late-inband.test" {
        FallbackHooks,
        HEDGE_BENCH_MIN_SILENT_FRACTION,
        newFallbackState,
        runFallbackLoop,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-late-inband.test" {
        clearCooldownsForKey,
        isOnCooldown,
        resetKeyLocalityCache,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-late-inband.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-lease.test" { initDb }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-lease.test" {
        newFallbackState,
        runFallbackLoop,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-lease.test" {
        acquireLease,
        inFlightForKey,
        releaseLease,
        resetLeases,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-lease.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-model-bench.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/fallback-loop-model-bench.test" { encrypt }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-model-bench.test" {
        MODEL_FAILURE_COOLDOWN_MS,
        MODEL_FAILURE_THRESHOLD,
        MODEL_FAILURE_WINDOW_MS,
        newFallbackState,
        recordRetryableFailure,
        recordUpstreamSuccess,
        resetModelFailureWindows,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-model-bench.test" {
        getActiveCooldownsForKeys,
        isOnCooldown,
        resetKeyLocalityCache,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-model-bench.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-provider-moment.test" {
        getDb,
        initDb,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-provider-moment.test" {
        newFallbackState,
        recordRetryableFailure,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-provider-moment.test" {
        RouteResult,
        getAllPenalties,
        isProviderMomentAttributionEnabled,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-size-skip.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/fallback-loop-size-skip.test" { encrypt }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-size-skip.test" {
        newFallbackState,
        recordRetryableFailure,
        resetModelFailureWindows,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-size-skip.test" {
        isOnCooldown,
        resetKeyLocalityCache,
    }
    "server/src/lib/output-cap" --> "server/src/__tests__/lib/fallback-loop-size-skip.test" {
        resetLearnedOutputCaps,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-size-skip.test" {
        RouteResult,
        clearAllPenalties,
        setRoutingStrategy,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop-ttfb-budget.test" {
        getDb,
        initDb,
        setSetting,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/fallback-loop-ttfb-budget.test" {
        newClientAbortError,
        newHedgeAbortError,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop-ttfb-budget.test" {
        FallbackHooks,
        newFallbackState,
        runFallbackLoop,
    }
    "server/src/lib/ttfb-budget" --> "server/src/__tests__/lib/fallback-loop-ttfb-budget.test" {
        invalidateTtfbBudgetCache,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-loop-ttfb-budget.test" {
        acquireLease,
        inFlightForKey,
        releaseLease,
        resetLeases,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop-ttfb-budget.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-loop.test" { getDb, initDb }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-loop.test" {
        AUTH_FAILURE_COOLDOWN_MS,
        AttemptRecord,
        DEFAULT_FALLBACK_TIME_BUDGET_MS,
        EMPTY_COMPLETION_STREAK_LIMIT,
        FallbackHooks,
        FallbackState,
        TRUNCATION_BENCH_MS,
        TRUNCATION_STREAK_LIMIT,
        classifyAttemptError,
        cooldownForError,
        exhaustedRetryError,
        formatAttemptTrail,
        getFallbackTimeBudgetMs,
        msUntilNextPacificMidnight,
        msUntilNextUtcMidnight,
        newFallbackState,
        recordRetryableFailure,
        recordUpstreamSuccess,
        resetEmptyCompletionStreaks,
        resetTruncationStreaks,
        runFallbackLoop,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/fallback-loop.test" {
        isDailyQuotaExhaustedError,
        isKeyAuthError,
        isModelScopedOverloadError,
        isProviderLevelError,
        newClientAbortError,
    }
    "server/src/lib/tool-validate" --> "server/src/__tests__/lib/fallback-loop.test" {
        invalidToolArgumentsError,
    }
    server.src.providers.base --> "server/src/__tests__/lib/fallback-loop.test" {
        providerHttpError,
        providerRequestError,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-loop.test" {
        RouteResult,
        getAllPenalties,
    }
    server.src.db.index --> "server/src/__tests__/lib/fallback-silent-window-upstream.test" {
        initDb,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/fallback-silent-window-upstream.test" {
        newFallbackState,
        runFallbackLoop,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/fallback-silent-window-upstream.test" {
        newHedgeAbortError,
    }
    "server/src/providers/openai-compat" --> "server/src/__tests__/lib/fallback-silent-window-upstream.test" {
        OpenAICompatProvider,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/fallback-silent-window-upstream.test" {
        acquireLease,
        releaseLease,
        resetLeases,
    }
    server.src.services.router --> "server/src/__tests__/lib/fallback-silent-window-upstream.test" {
        RouteResult,
    }
    "server/src/lib/file-permissions" --> "server/src/__tests__/lib/file-permissions.test" {
        ExecFileSyncLike,
        restrictAllToOwner,
        restrictDirToOwner,
        restrictToOwner,
        windowsRestrictArgs,
    }
    "server/src/lib/gemini-wire" --> "server/src/__tests__/lib/gemini-schema-compat.test" {
        sanitizeForGemini,
    }
    "server/src/lib/gemini-wire" --> "server/src/__tests__/lib/gemini-wire.test" {
        effortFromGeminiThinking,
        estimateGeminiTokens,
        geminiContentsToMessages,
        geminiPartsFromResult,
        geminiResponseFormat,
        geminiToolChoice,
        geminiToolsToChatTools,
        sanitizeForGemini,
    }
    "server/src/lib/graceful-shutdown" --> "server/src/__tests__/lib/graceful-shutdown.test" {
        installGracefulShutdown,
    }
    server.src.lib.guardrails --> "server/src/__tests__/lib/guardrails.test" {
        MAX_CONSECUTIVE_UPSTREAM_FAILS_SETTING,
        REQUEST_MAX_TOKENS_BUDGET_SETTING,
        TOKEN_BUDGET_OUTPUT_CAP,
        applyTokenBudget,
        getMaxConsecutiveUpstreamFails,
        getRequestMaxTokensBudget,
        newBreaker,
        recordBreakerFailure,
        tokenBudgetMessage,
    }
    "server/src/lib/header-value" --> "server/src/__tests__/lib/header-value.test" {
        routedViaValue,
        safeHeaderValue,
    }
    "server/src/lib/image-normalize" --> "server/src/__tests__/lib/image-normalize-no-sharp.test";
    "server/src/lib/image-normalize" --> "server/src/__tests__/lib/image-normalize-old-cpu.test";
    "server/src/lib/image-normalize" --> "server/src/__tests__/lib/image-normalize.test" {
        normalizeMessageImages,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/lib/key-parser-models.test" {
        parseKeysFromFile,
        parseModelList,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/lib/key-parser.test" {
        AUTH_JSON_PROVIDER_MAP,
        detectPlatform,
        looksLikeApiKey,
        parseAuthJson,
        parseCsv,
        parseDotEnv,
        parseExportJson,
        parseJson,
        parseKeysFromFile,
        stripJsoncComments,
        stripTrailingCommas,
    }
    "server/src/lib/log-redaction" --> "server/src/__tests__/lib/log-redaction.test" {
        installLogRedaction,
        redactSecrets,
    }
    server.src.lib.loopback --> "server/src/__tests__/lib/loopback.test" {
        forwardedPeerAddress,
        isLoopbackAddress,
        isLoopbackRequest,
    }
    "server/src/lib/min-context-window" --> "server/src/__tests__/lib/min-context-window.test" {
        MIN_CONTEXT_WINDOW_PRESETS,
        MIN_CONTEXT_WINDOW_SETTING,
        minContextWindowFloor,
        passesContextWindowFloor,
    }
    server.src.db.index --> "server/src/__tests__/lib/min-context-window.test" {
        getDb,
        getSetting,
        initDb,
        setSetting,
    }
    "server/src/lib/output-cap" --> "server/src/__tests__/lib/output-cap.test" {
        learnOutputCapFromError,
        learnedOutputCap,
        parseMaxTokensCeiling,
        resetLearnedOutputCaps,
        routeOutputBudget,
    }
    "server/src/lib/process-safety-net" --> "server/src/__tests__/lib/process-safety-net.test";
    "server/src/lib/process-safety-net" --> "server/src/__tests__/lib/process-safety-net.test" {
        SafetyNetHooks,
        classifyProcessError,
        guardStdio,
        handleProcessError,
        isBrokenPipeWrite,
        isTransportError,
    }
    server.src.providers.gizmo --> "server/src/__tests__/lib/provider-400-retry.test" {
        GizmoProvider,
    }
    server.src.providers.jamai --> "server/src/__tests__/lib/provider-400-retry.test" {
        JamaiProvider,
    }
    server.src.providers.kenari --> "server/src/__tests__/lib/provider-400-retry.test" {
        KenariProvider,
    }
    server.src.providers.kiosapi --> "server/src/__tests__/lib/provider-400-retry.test" {
        KiosAPIProvider,
    }
    server.src.providers.novai --> "server/src/__tests__/lib/provider-400-retry.test" {
        NovaiProvider,
    }
    server.src.providers.freeinference --> "server/src/__tests__/lib/provider-400-retry.test" {
        FreeInferenceProvider,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/provider-400-retry.test" {
        isModelNotFoundError,
        isProviderBadRequestError,
        isRetryableError,
    }
    "server/src/lib/provider-identity" --> "server/src/__tests__/lib/provider-identity.test" {
        endpointHost,
        providerDisplayName,
        providerIdFor,
    }
    "server/src/lib/endpoint-scope" --> "server/src/__tests__/lib/provider-identity.test" {
        endpointScopeForBaseUrl,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/provider-rejection-no-bench.test" {
        FallbackHooks,
        newFallbackState,
        runFallbackLoop,
    }
    server.src.db.index --> "server/src/__tests__/lib/provider-rejection-no-bench.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/provider-rejection-no-bench.test" {
        encrypt,
    }
    server.src.providers.base --> "server/src/__tests__/lib/provider-rejection-no-bench.test" {
        providerRequestError,
    }
    server.src.services.ratelimit --> "server/src/__tests__/lib/provider-rejection-no-bench.test" {
        isOnCooldown,
        resetKeyLocalityCache,
    }
    server.src.services.router --> "server/src/__tests__/lib/provider-rejection-no-bench.test" {
        RouteResult,
    }
    "server/src/lib/provider-size-parser" --> "server/src/__tests__/lib/provider-size-parser.test" {
        parseProviderReportedSize,
    }
    "server/src/lib/provider-timeout" --> "server/src/__tests__/lib/provider-timeout.test" {
        DEFAULT_STREAM_STALL_TIMEOUT_MS,
        providerTimeoutEnvName,
        providerTimeoutMs,
        resetTimeoutWarnings,
        streamStallTimeoutMs,
    }
    server.src.lib.proxy --> "server/src/__tests__/lib/proxy-fetch-relay-integration.test" {
        FETCH_RELAY_AUTH_HEADER,
        FETCH_RELAY_TARGET_HEADER,
        applyFetchRelayToken,
        applyProxyEnabled,
        applyProxyMode,
        applyProxyUrl,
        proxyFetch,
    }
    server.src.lib.proxy --> "server/src/__tests__/lib/proxy-fetch-relay.test" {
        FETCH_RELAY_AUTH_HEADER,
        FETCH_RELAY_TARGET_HEADER,
        applyFetchRelayToken,
        applyProxyBypass,
        applyProxyEnabled,
        applyProxyMode,
        applyProxyUrl,
        getProxyMode,
        probeProxyUrl,
        proxyFetch,
    }
    server.src.db.index --> "server/src/__tests__/lib/proxy-restore.test" {
        getDb,
        initDb,
        setSetting,
    }
    server.src.lib.proxy --> "server/src/__tests__/lib/proxy-restore.test" {
        applyFetchRelayToken,
        applyProxyBypass,
        applyProxyEnabled,
        applyProxyMode,
        applyProxyUrl,
        encodeFetchRelayToken,
        getFetchRelayToken,
        getNoProxyRules,
        getProxyBypassPlatforms,
        getProxyMode,
        getProxyUrl,
        isProxyEnabled,
        restoreProxySettings,
    }
    server.src.db.index --> "server/src/__tests__/lib/proxy-websocket.test" { getDb, initDb }
    server.src.lib.proxy --> "server/src/__tests__/lib/proxy-websocket.test" {
        applyProxyBypass,
        applyProxyEnabled,
        applyProxyMode,
        applyProxyUrl,
        openProviderWebSocket,
        withKeyProxy,
    }
    server.src.lib.proxy --> "server/src/__tests__/lib/proxy.test" {
        DEFAULT_PROXY_PROBE_TARGET,
        PROXY_MODES,
        PROXY_SCHEMES,
        applyProxyBypass,
        applyProxyEnabled,
        applyProxyMode,
        applyProxyUrl,
        describeAbort,
        getNoProxyRules,
        getProxyBypassPlatforms,
        getProxyMode,
        getProxyUrl,
        isProxyActive,
        isProxyEnabled,
        isSocksProxyUrl,
        normalizeProxyUrl,
        parseRegProxy,
        parseScutilProxy,
        probeProxyUrl,
        proxyFetch,
        socksHostnameLookup,
        withKeyProxy,
    }
    server.src.db.index --> "server/src/__tests__/lib/request-attempts.test" { getDb, initDb }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/request-attempts.test" {
        FallbackHooks,
        newFallbackState,
        runFallbackLoop,
    }
    "server/src/lib/request-log" --> "server/src/__tests__/lib/request-attempts.test" { logRequest }
    "server/src/services/request-retention" --> "server/src/__tests__/lib/request-attempts.test" {
        pruneRequestAnalytics,
    }
    server.src.services.router --> "server/src/__tests__/lib/request-attempts.test" { RouteResult }
    server.src.db.index --> "server/src/__tests__/lib/request-caller.test" { getDb, initDb }
    "server/src/lib/request-log" --> "server/src/__tests__/lib/request-caller.test" { logRequest }
    "server/src/lib/sampling-params" --> "server/src/__tests__/lib/sampling-params.test";
    "server/src/lib/sampling-params" --> "server/src/__tests__/lib/sampling-params.test" {
        EXTENDED_SAMPLING_KEYS,
        REASONING_EFFORTS,
        extendedBodyParams,
        normalizeReasoningEffort,
        pickSamplingParams,
        supportedParametersFor,
        supportedParametersForPlatforms,
    }
    "server/src/lib/served-model" --> "server/src/__tests__/lib/served-model.test" {
        normalizeModelIdForDrift,
        observeServedModel,
        resetServedModelObservations,
    }
    server.src.db.index --> "server/src/__tests__/lib/server-logs-rate-cap.test" { getDb, initDb }
    "server/src/lib/server-logs" --> "server/src/__tests__/lib/server-logs-rate-cap.test" {
        PERSIST_MAX_PER_SECOND,
        initServerLogs,
        recordLogEntry,
        resetServerLogsForTest,
        ringSnapshot,
    }
    "server/src/lib/stream-keepalive" --> "server/src/__tests__/lib/stream-keepalive.test" {
        startStreamKeepalive,
        streamKeepaliveMs,
    }
    "server/src/lib/structured-output" --> "server/src/__tests__/lib/structured-output.test" {
        enforceJsonContent,
    }
    server.src.db.index --> "server/src/__tests__/lib/system-date.test" { initDb, setSetting }
    "server/src/lib/system-date" --> "server/src/__tests__/lib/system-date.test" {
        SYSTEM_DATE_SETTING,
        ToolLike,
        alreadyHasDateContext,
        formatSystemDatePrompt,
        getSystemDateMode,
        hasWebSearchInRequest,
        maybeInjectSystemDate,
        setSystemDateMode,
    }
    server.src.db.index --> "server/src/__tests__/lib/system-prompt.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/lib/system-prompt.test" { encrypt }
    "server/src/lib/system-prompt" --> "server/src/__tests__/lib/system-prompt.test" {
        CLIENT_PROFILE_KEY_PREFIX,
        hashClientProfileKey,
        mintClientProfileKey,
        prependSystemPrompt,
        resolveAuth,
    }
    "server/src/lib/task-type" --> "server/src/__tests__/lib/task-type.test" {
        TASK_TYPE_HEADER,
        deriveTaskType,
        parseTaskTypeHeader,
        resolveTaskType,
    }
    "server/src/lib/think-tags" --> "server/src/__tests__/lib/think-tags.test" {
        ThinkTagStreamFilter,
        extractThinkFromMessage,
        extractThinkTagsFromStream,
        splitThinkTag,
    }
    "server/src/lib/tool-args" --> "server/src/__tests__/lib/tool-args.test" {
        repairToolArguments,
        stripSchemaKeys,
        toolSchemaMap,
    }
    "server/src/lib/tool-call-rescue" --> "server/src/__tests__/lib/tool-call-rescue.test" {
        containsDialectMarker,
        couldBecomeDialectMarker,
        rescueInlineToolCalls,
        startsWithDialectMarker,
    }
    "server/src/lib/tool-validate" --> "server/src/__tests__/lib/tool-validate.test" {
        TOOL_ARGUMENT_VALIDATION_SETTING,
        invalidToolArgumentsError,
        invalidToolCallReasons,
        isToolArgumentValidationEnabled,
        stableStringify,
        validateToolArguments,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/tool-validate.test" {
        isRetryableError,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/lib/tool-validate.test" {
        classifyAttemptError,
    }
    server.src.db.index --> "server/src/__tests__/lib/tool-validate.test" {
        getDb,
        initDb,
        setSetting,
    }
    server.src.db.index --> "server/src/__tests__/lib/ttfb-budget.test" {
        getDb,
        initDb,
        setSetting,
    }
    "server/src/lib/ttfb-budget" --> "server/src/__tests__/lib/ttfb-budget.test" {
        getEndpointTimeBudgetMs,
        getEndpointTtfbStats,
        invalidateTtfbBudgetCache,
    }
    "server/src/lib/sampling-params" --> "server/src/__tests__/lib/unified-max-tokens.test" {
        UNIFIED_MAX_TOKENS_AUTO,
        UNIFIED_MAX_TOKENS_SETTING,
        defaultMaxTokensFor,
        maxTokensCapFor,
        resolveMaxTokens,
        unifiedMaxTokensCap,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/lib/upstream-classification.test" {
        isInBandQuotaNotice,
        isUpstreamClassificationOutput,
    }
    "server/src/lib/url-guard" --> "server/src/__tests__/lib/url-guard.test" {
        assertProviderUrlAllowed,
        assessProviderUrl,
        classifyIp,
        isLoopbackOrPrivateHostname,
        isLoopbackOrPrivateUrl,
    }
    "server/src/lib/wake-detect" --> "server/src/__tests__/lib/wake-detect.test" {
        _resetForTests,
        startWakeDetect,
        stopWakeDetect,
    }
    "server/src/providers/openai-compat" --> "server/src/__tests__/providers/abort-signal.test" {
        OpenAICompatProvider,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/providers/abort-signal.test" {
        isClientAbortError,
        newClientAbortError,
    }
    server.src.providers.aclide --> "server/src/__tests__/providers/aclide.test" { AclideProvider }
    server.src.providers.index --> "server/src/__tests__/providers/aclide.test" { getProvider }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/aclide.test" {
        AUTH_JSON_PROVIDER_MAP,
        detectPlatform,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/providers/aclide.test" {
        isRetryableError,
    }
    server.src.providers.aihorde --> "server/src/__tests__/providers/aihorde.test" {
        AIHordeProvider,
    }
    server.src.providers.beatapi --> "server/src/__tests__/providers/beatapi-serpsearch.test" {
        BeatApiProvider,
    }
    server.src.providers.serpsearch --> "server/src/__tests__/providers/beatapi-serpsearch.test" {
        SerpSearchProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/beatapi-serpsearch.test" {
        getProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/beatapi-serpsearch.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    server.src.providers.inferbase --> "server/src/__tests__/providers/catalog-gateways.test" {
        INFERBASE_BASE_URL,
        InferbaseProvider,
    }
    server.src.providers.apinex --> "server/src/__tests__/providers/catalog-gateways.test" {
        APINEX_BASE_URL,
        ApinexProvider,
    }
    server.src.providers.simplellm --> "server/src/__tests__/providers/catalog-gateways.test" {
        SIMPLELLM_BASE_URL,
        SimpleLLMProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/catalog-gateways.test" {
        getProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/catalog-gateways.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/providers/catalog-gateways.test" {
        inferPoolForPlatform,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/providers/catalog-gateways.test" {
        applyCatalog,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/providers/catalog-gateways.test" {
        isBuiltinDiscoveryEligible,
    }
    server.src.db.index --> "server/src/__tests__/providers/catalog-gateways.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/providers/cheapllm.test" { getProvider }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/cheapllm.test" {
        AUTH_JSON_PROVIDER_MAP,
        detectPlatform,
    }
    server.src.providers.index --> "server/src/__tests__/providers/clod-speechify-blaze.test" {
        getProvider,
        hasProvider,
    }
    server.src.providers.cloudflare --> "server/src/__tests__/providers/cloudflare.test" {
        CloudflareProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/cn-providers.test" {
        getProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/cn-providers.test" {
        AUTH_JSON_PROVIDER_MAP,
        detectPlatform,
    }
    server.src.providers.cohere --> "server/src/__tests__/providers/cohere.test" { CohereProvider }
    server.src.providers.index --> "server/src/__tests__/providers/decision-only.test" {
        getProvider,
    }
    server.src.providers.cloudflare --> "server/src/__tests__/providers/default-max-tokens.test" {
        CloudflareProvider,
    }
    "server/src/providers/openai-compat" --> "server/src/__tests__/providers/default-max-tokens.test" {
        OpenAICompatProvider,
    }
    "server/src/lib/sampling-params" --> "server/src/__tests__/providers/default-max-tokens.test" {
        defaultMaxTokensFor,
        resolveMaxTokens,
    }
    server.src.providers.freeai --> "server/src/__tests__/providers/freeai.test" {
        FreeAiProvider,
        freeAiAudioUrl,
    }
    server.src.providers.index --> "server/src/__tests__/providers/freeai.test" { hasProvider }
    server.src.db.index --> "server/src/__tests__/providers/freeai.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/providers/freeai.test" { encrypt }
    server.src.services.health --> "server/src/__tests__/providers/freeai.test" { checkKeyHealth }
    server.src.db.index --> "server/src/__tests__/providers/freeinference.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/providers/freeinference.test" {
        getProvider,
    }
    server.src.providers.freeinference --> "server/src/__tests__/providers/freeinference.test" {
        FREEINFERENCE_BASE_URL,
        FreeInferenceProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/freeinference.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/providers/freeinference.test" {
        inferPoolForPlatform,
    }
    server.src.db.index --> "server/src/__tests__/providers/freemodel.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/providers/freemodel.test" { getProvider }
    server.src.providers.freemodel --> "server/src/__tests__/providers/freemodel.test" {
        FREEMODEL_BASE_URL,
        FreeModelProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/freemodel.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/providers/freemodel.test" {
        inferPoolForPlatform,
        parseQuotaObservationsFromResponse,
    }
    server.src.providers.gizmo --> "server/src/__tests__/providers/gizmo-blockrun.test" {
        GizmoProvider,
    }
    server.src.providers.blockrun --> "server/src/__tests__/providers/gizmo-blockrun.test" {
        BlockRunProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/gizmo-blockrun.test" {
        getProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/gizmo-blockrun.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/providers/gizmo-blockrun.test" {
        BUILTIN_DISCOVERY_PLATFORMS,
    }
    "server/src/lib/sampling-params" --> "server/src/__tests__/providers/gizmo-blockrun.test" {
        extendedBodyParams,
        platformDropsResponseFormat,
    }
    server.src.providers.google --> "server/src/__tests__/providers/google-auth-header.test" {
        GoogleProvider,
    }
    server.src.providers.google --> "server/src/__tests__/providers/google-params.test" {
        toGeminiExtendedConfig,
    }
    server.src.providers.google --> "server/src/__tests__/providers/google-schema.test" {
        sanitizeForGemini,
    }
    server.src.providers.google --> "server/src/__tests__/providers/google.test" { GoogleProvider }
    "server/src/lib/error-classify" --> "server/src/__tests__/providers/google.test" {
        isStreamTruncatedError,
    }
    server.src.providers.jamai --> "server/src/__tests__/providers/jamai.test" {
        JamaiProvider,
        jamaiHeaders,
    }
    server.src.providers.index --> "server/src/__tests__/providers/jamai.test" { getProvider }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/jamai.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    "server/src/lib/sampling-params" --> "server/src/__tests__/providers/jamai.test" {
        supportedParametersFor,
    }
    server.src.providers.kenari --> "server/src/__tests__/providers/kenari.test" { KenariProvider }
    server.src.db.index --> "server/src/__tests__/providers/kenari.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/providers/kenari.test" { getProvider }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/providers/kenari.test" {
        isBuiltinDiscoveryEligible,
    }
    "server/src/providers/openai-compat" --> "server/src/__tests__/providers/keyless-bearer-1331.test" {
        OpenAICompatProvider,
        isAnonymousCredential,
    }
    server.src.providers.index --> "server/src/__tests__/providers/keyless-bearer-1331.test" {
        resolveProvider,
    }
    server.src.lib.credential --> "server/src/__tests__/providers/keyless-bearer-1331.test" {
        bearerAuthHeader,
    }
    server.src.providers.kiosapi --> "server/src/__tests__/providers/kiosapi.test" {
        KiosAPIProvider,
    }
    server.src.db.index --> "server/src/__tests__/providers/kiosapi.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/providers/kiosapi.test" { getProvider }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/kiosapi.test" { detectPlatform }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/providers/kiosapi.test" {
        isBuiltinDiscoveryEligible,
    }
    server.src.providers.index --> "server/src/__tests__/providers/llmkiwi-tokenreply.test" {
        getProvider,
    }
    server.src.providers.llmkiwi --> "server/src/__tests__/providers/llmkiwi-tokenreply.test" {
        LlmKiwiProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/llmkiwi-tokenreply.test" {
        AUTH_JSON_PROVIDER_MAP,
        detectPlatform,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/providers/llmkiwi-tokenreply.test" {
        inferQuotaPoolKey,
    }
    server.src.providers.llmtr --> "server/src/__tests__/providers/llmtr-validation-pacing.test" {
        LLMTR_VALIDATION_GAP_ENV,
        LLMTR_VALIDATION_MIN_GAP_MS,
        LlmtrProvider,
        LlmtrProviderOptions,
    }
    server.src.providers.llmtr --> "server/src/__tests__/providers/llmtr.test" { LlmtrProvider }
    server.src.providers.index --> "server/src/__tests__/providers/llmtr.test" { getProvider }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/llmtr.test" {
        AUTH_JSON_PROVIDER_MAP,
        detectPlatform,
        parseKeysFromFile,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/providers/llmtr.test" {
        BUILTIN_DISCOVERY_PLATFORMS,
    }
    server.src.providers.index --> "server/src/__tests__/providers/lucidity-airforce-dreamprompting-waterfall-logfare.test" {
        getProvider,
        hasProvider,
    }
    server.src.providers.modelscope --> "server/src/__tests__/providers/modelscope.test" {
        ModelScopeProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/modelscope.test" {
        getProvider,
        hasProvider,
        resolveProvider,
    }
    server.src.providers.base --> "server/src/__tests__/providers/modelscope.test" {
        KeyValidationFailure,
    }
    server.src.providers.moondream --> "server/src/__tests__/providers/moondream.test" {
        MoondreamProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/moondream.test" { getProvider }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/moondream.test" {
        AUTH_JSON_PROVIDER_MAP,
        detectPlatform,
        parseKeysFromFile,
    }
    "server/src/lib/sampling-params" --> "server/src/__tests__/providers/moondream.test" {
        supportedParametersFor,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/providers/moondream.test" {
        isRetryableError,
    }
    server.src.db.index --> "server/src/__tests__/providers/nabh.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/providers/nabh.test" { getProvider }
    server.src.providers.nabh --> "server/src/__tests__/providers/nabh.test" {
        NABH_BASE_URL,
        NabhProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/nabh.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/providers/nabh.test" {
        inferPoolForPlatform,
    }
    "server/src/providers/openai-compat" --> "server/src/__tests__/providers/openai-compat.test" {
        OpenAICompatProvider,
        inBandCreditsError,
        inBandErrorEnvelope,
        isMaxTokensUnsupportedError,
        usesMaxCompletionTokens,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/providers/openai-compat.test" {
        stubPublicDns,
    }
    server.src.providers.plugsky --> "server/src/__tests__/providers/plugsky.test" {
        PLUGSKY_BASE_URL,
        PlugskyProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/plugsky.test" { getProvider }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/plugsky.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    server.src.providers.pollinations --> "server/src/__tests__/providers/pollinations.test" {
        PollinationsProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/pollinations.test" {
        getProvider,
        hasProvider,
        resolveProvider,
    }
    server.src.providers.base --> "server/src/__tests__/providers/pollinations.test" {
        KeyValidationFailure,
    }
    server.src.providers.index --> "server/src/__tests__/providers/powertokens.test" { getProvider }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/powertokens.test" {
        AUTH_JSON_PROVIDER_MAP,
        detectPlatform,
    }
    server.src.providers.puter --> "server/src/__tests__/providers/puter.test" { PuterProvider }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/providers/puter.test" {
        autoRegistrable,
    }
    "server/src/services/specialist-text" --> "server/src/__tests__/providers/puter.test" {
        specialistTask,
    }
    server.src.services.decision --> "server/src/__tests__/providers/puter.test" { isClairic }
    "server/src/providers/openai-compat" --> "server/src/__tests__/providers/quota-api-poll.test" {
        OpenAICompatProvider,
    }
    server.src.db.index --> "server/src/__tests__/providers/quota-api-poll.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/providers/quota-api-poll.test" {
        resolveProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/radeon.test" { getProvider }
    "server/src/providers/openai-compat" --> "server/src/__tests__/providers/read-sse-frames.test" {
        OpenAICompatProvider,
    }
    "server/src/lib/provider-timeout" --> "server/src/__tests__/providers/read-sse-frames.test" {
        resetTimeoutWarnings,
    }
    server.src.providers.index --> "server/src/__tests__/providers/reasoning-timeouts.test" {
        resolveProvider,
    }
    server.src.providers.cloudflare --> "server/src/__tests__/providers/reasoning-timeouts.test" {
        CloudflareProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/recurring-credit-gateways.test" {
        getProvider,
        hasProvider,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/providers/recurring-credit-gateways.test" {
        isRetryableError,
    }
    server.src.providers.index --> "server/src/__tests__/providers/router9-septor.test" {
        getProvider,
        hasProvider,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/providers/router9-septor.test" {
        isRetryableError,
    }
    server.src.providers.sail --> "server/src/__tests__/providers/sail.test" { SailProvider }
    server.src.providers.tavily --> "server/src/__tests__/providers/search-providers.test" {
        TavilyProvider,
    }
    server.src.providers.exa --> "server/src/__tests__/providers/search-providers.test" {
        ExaProvider,
    }
    server.src.providers.firecrawl --> "server/src/__tests__/providers/search-providers.test" {
        FirecrawlProvider,
    }
    server.src.providers.linkup --> "server/src/__tests__/providers/search-providers.test" {
        LinkupProvider,
    }
    server.src.providers.parallel --> "server/src/__tests__/providers/search-providers.test" {
        ParallelProvider,
    }
    server.src.providers.keenable --> "server/src/__tests__/providers/search-providers.test" {
        KeenableProvider,
    }
    server.src.providers.outcrawl --> "server/src/__tests__/providers/search-providers.test" {
        OutcrawlProvider,
    }
    server.src.providers.tinyfish --> "server/src/__tests__/providers/search-providers.test" {
        TinyFishProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/search-providers.test" {
        getProvider,
    }
    server.src.db.index --> "server/src/__tests__/providers/silvr.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/providers/silvr.test" { getProvider }
    server.src.providers.silvr --> "server/src/__tests__/providers/silvr.test" {
        SILVR_BASE_URL,
        SilvrProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/silvr.test" {
        parseKeysFromFile,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/providers/silvr.test" {
        inferPoolForPlatform,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/providers/silvr.test" {
        isBuiltinDiscoveryEligible,
    }
    server.src.providers.speka --> "server/src/__tests__/providers/speka.test" { SpekaProvider }
    server.src.providers.index --> "server/src/__tests__/providers/speka.test" { getProvider }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/speka.test" {
        AUTH_JSON_PROVIDER_MAP,
        detectPlatform,
        parseKeysFromFile,
    }
    server.src.providers.base --> "server/src/__tests__/providers/stated-retry.test" {
        parseStatedRetryMs,
        providerHttpError,
    }
    "server/src/providers/openai-compat" --> "server/src/__tests__/providers/stream-first-byte.test" {
        OpenAICompatProvider,
    }
    server.src.providers.google --> "server/src/__tests__/providers/stream-first-byte.test" {
        GoogleProvider,
    }
    "server/src/lib/provider-timeout" --> "server/src/__tests__/providers/stream-first-byte.test" {
        resetTimeoutWarnings,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/providers/stream-first-byte.test" {
        isClientAbortError,
        isRetryableError,
        newClientAbortError,
    }
    server.src.providers.typhoon --> "server/src/__tests__/providers/typhoon.test" {
        TYPHOON_BASE_URL,
        TyphoonProvider,
    }
    server.src.providers.index --> "server/src/__tests__/providers/typhoon.test" { getProvider }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/typhoon.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    server.src.db.index --> "server/src/__tests__/providers/unified-max-tokens-cap.test" {
        initDb,
        setSetting,
    }
    "server/src/providers/openai-compat" --> "server/src/__tests__/providers/unified-max-tokens-cap.test" {
        OpenAICompatProvider,
    }
    server.src.providers.cloudflare --> "server/src/__tests__/providers/unified-max-tokens-cap.test" {
        CloudflareProvider,
    }
    server.src.providers.cohere --> "server/src/__tests__/providers/unified-max-tokens-cap.test" {
        CohereProvider,
    }
    server.src.providers.google --> "server/src/__tests__/providers/unified-max-tokens-cap.test" {
        GoogleProvider,
    }
    server.src.providers.aihorde --> "server/src/__tests__/providers/unified-max-tokens-cap.test" {
        AIHordeProvider,
    }
    "server/src/lib/sampling-params" --> "server/src/__tests__/providers/unified-max-tokens-cap.test" {
        UNIFIED_MAX_TOKENS_AUTO,
        UNIFIED_MAX_TOKENS_SETTING,
        defaultMaxTokensFor,
    }
    server.src.providers.zhipu --> "server/src/__tests__/providers/zhipu.test" { ZhipuProvider }
    server.src.db.index --> "server/src/__tests__/providers/zro.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/providers/zro.test" { getProvider }
    server.src.providers.zro --> "server/src/__tests__/providers/zro.test" {
        ZRO_BASE_URL,
        ZroProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/providers/zro.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/providers/zro.test" {
        inferPoolForPlatform,
    }
    server.src.app --> "server/src/__tests__/routes/admin-rate-limit.test" { createApp }
    server.src.middleware.rateLimit --> "server/src/__tests__/routes/admin-rate-limit.test" {
        createAdminRateLimiter,
    }
    server.src.db.index --> "server/src/__tests__/routes/admin-rate-limit.test" { initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/admin-rate-limit.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/agent-web-search.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/agent-web-search.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
        setSetting,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/agent-web-search.test" { encrypt }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/agent-web-search.test" {
        mintDashboardToken,
    }
    "server/src/lib/web-search-tool" --> "server/src/__tests__/routes/agent-web-search.test" {
        encodeHitContent,
        filterHitsByDomain,
    }
    "server/src/__tests__/helpers/search-engines" --> "server/src/__tests__/routes/agent-web-search.test" {
        seedSearchEngines,
    }
    server.src.db.index --> "server/src/__tests__/helpers/search-engines" { getDb }
    server.src.app --> "server/src/__tests__/routes/allowed-hosts.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/allowed-hosts.test" { initDb }
    server.src.app --> "server/src/__tests__/routes/analytics-client.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/analytics-client.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/analytics-client.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/analytics-request-attempts.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/analytics-request-attempts.test" {
        getDb,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/analytics-request-attempts.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/analytics-requests.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/analytics-requests.test" { getDb, initDb }
    "server/src/lib/request-log" --> "server/src/__tests__/routes/analytics-requests.test" {
        logRequest,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/analytics-requests.test" {
        mintDashboardToken,
    }
    "server/src/lib/client-context" --> "server/src/__tests__/routes/analytics-requests.test";
    server.src.app --> "server/src/__tests__/routes/analytics.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/analytics.test" { getDb, initDb }
    "server/src/lib/request-log" --> "server/src/__tests__/routes/analytics.test" { logRequest }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/analytics.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/anthropic-documents.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/anthropic-documents.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/anthropic-documents.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/anthropic-fallback-convergence.test" {
        createApp,
    }
    server.src.db.index --> "server/src/__tests__/routes/anthropic-fallback-convergence.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.app --> "server/src/__tests__/routes/anthropic-safeguards.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/anthropic-safeguards.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.routes.anthropic --> "server/src/__tests__/routes/anthropic-safeguards.test" {
        extractAnthropicCompat,
        requestsAutoModeReview,
        safeguardResultsFor,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/anthropic-safeguards.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/anthropic.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/anthropic.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.chain --> "server/src/__tests__/routes/anthropic.test" {
        addToActiveChain,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/anthropic.test" { encrypt }
    "server/src/services/model-groups" --> "server/src/__tests__/routes/anthropic.test" {
        setUnifyEnabled,
        setUnifyOverrides,
    }
    server.src.services.router --> "server/src/__tests__/routes/anthropic.test" {
        getRoutingStrategy,
        setRoutingStrategy,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/anthropic.test" {
        mintDashboardToken,
    }
    server.src.db.index --> server.src.__tests__.helpers.chain { getDb }
    "server/src/services/profile-models" --> server.src.__tests__.helpers.chain {
        getActiveProfileId,
    }
    server.src.app --> "server/src/__tests__/routes/api-compression.test" { apiCompressionFilter }
    server.src.app --> "server/src/__tests__/routes/audio-transcriptions.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/audio-transcriptions.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/audio-transcriptions.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/routes/audio-transcriptions.test" {
        MAX_TRANSCRIPTION_BYTES,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/audio-transcriptions.test" {
        clearCooldownsForKey,
    }
    server.src.routes.auth --> "server/src/__tests__/routes/auth-desktop-session.test" {
        authRouter,
    }
    server.src.db.index --> "server/src/__tests__/routes/auth-desktop-session.test" {
        getDb,
        initDb,
    }
    server.src.routes.auth --> "server/src/__tests__/routes/auth-login-identifier.test" {
        authRouter,
    }
    server.src.db.index --> "server/src/__tests__/routes/auth-login-identifier.test" {
        getDb,
        initDb,
    }
    server.src.app --> "server/src/__tests__/routes/auth-login-throttle.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/auth-login-throttle.test" { getDb, initDb }
    server.src.app --> "server/src/__tests__/routes/auth-oidc.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/auth-oidc.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/auth-oidc.test" { encrypt }
    "server/src/services/declarative-config" --> "server/src/__tests__/routes/auth-oidc.test" {
        applyDeclarativeConfig,
    }
    server.src.services.oidc --> "server/src/__tests__/routes/auth-oidc.test" { resetOidcState }
    server.src.db.types --> "server/src/services/declarative-config" { Db }
    server.src.db.index --> "server/src/services/declarative-config" { getDb, getSetting }
    server.src.lib.crypto --> "server/src/services/declarative-config" { encrypt }
    server.src.providers.index --> "server/src/services/declarative-config" { resolveProvider }
    server.src.services.router --> "server/src/services/declarative-config" {
        setCustomWeights,
        setKeySelectionStrategy,
        setRoutingStrategy,
    }
    "server/src/services/profile-models" --> "server/src/services/declarative-config" {
        ensureModelInProfiles,
    }
    "server/src/services/custom-model-seed" --> "server/src/services/declarative-config" {
        customModelSeed,
    }
    server.src.services.oidc --> "server/src/services/declarative-config" {
        setDeclarativeOidcConfig,
    }
    "server/src/services/catalog-sync" --> "server/src/services/declarative-config" {
        SETTING_LICENSE_KEY,
        storeActivatedLicense,
        syncCatalog,
        validateLicenseKey,
    }
    "server/src/lib/endpoint-scope" --> "server/src/services/declarative-config" {
        endpointRefMatches,
        endpointScopeForBaseUrl,
    }
    "server/src/services/model-state" --> "server/src/services/declarative-config" {
        ModelOverridePatch,
        clearCatalogModelTombstone,
        isCatalogManagedModel,
        upsertModelOverrides,
    }
    server.src.routes.auth --> "server/src/__tests__/routes/auth-reset-password.test" { authRouter }
    server.src.db.index --> "server/src/__tests__/routes/auth-reset-password.test" { initDb }
    "server/src/lib/reset-code" --> "server/src/__tests__/routes/auth-reset-password.test" {
        clearResetCode,
        getResetCode,
    }
    server.src.routes.auth --> "server/src/__tests__/routes/auth-setup-code.test" { authRouter }
    server.src.db.index --> "server/src/__tests__/routes/auth-setup-code.test" { getDb, initDb }
    "server/src/lib/setup-code" --> "server/src/__tests__/routes/auth-setup-code.test" {
        generateSetupCode,
        getSetupCode,
    }
    server.src.app --> "server/src/__tests__/routes/auth.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/auth.test" { initDb }
    server.src.app --> "server/src/__tests__/routes/auto-alias-strategy.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/auto-alias-strategy.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/auto-alias-strategy.test" { encrypt }
    server.src.services.router --> "server/src/__tests__/routes/auto-alias-strategy.test" {
        refreshStatsCache,
        resolveRoutingChain,
        setRoutingStrategy,
    }
    server.src.app --> "server/src/__tests__/routes/backups.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/backups.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/backups.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.services.backups --> "server/src/__tests__/routes/backups.test" {
        createBackup,
        restoreBackup,
    }
    server.src.app --> "server/src/__tests__/routes/body-limit.test" { createApp }
    server.src.lib.config --> "server/src/__tests__/routes/body-limit.test" { loadConfig }
    server.src.db.index --> "server/src/__tests__/routes/body-limit.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.app --> "server/src/__tests__/routes/builtin-model-discovery.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/builtin-model-discovery.test" {
        getDb,
        initDb,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/routes/builtin-model-discovery.test" {
        resetBuiltinDiscoveryThrottle,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/builtin-model-discovery.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/claude-alias-openai-routes.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/claude-alias-openai-routes.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/claude-alias-openai-routes.test" {
        encrypt,
    }
    server.src.services.router --> "server/src/__tests__/routes/claude-alias-openai-routes.test" {
        setRoutingStrategy,
    }
    "server/src/services/anthropic-map" --> "server/src/__tests__/routes/claude-alias-openai-routes.test" {
        setClaudeModelMap,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/claude-alias-openai-routes.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    cli.src.index --> "server/src/__tests__/routes/cli-keys.test" { main }
    server.src.db.index --> "server/src/__tests__/routes/cli-keys.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/cli-keys.test" { decrypt }
    server.src.middleware.requireAuth --> "server/src/__tests__/routes/cli-keys.test" {
        requireAuth,
    }
    server.src.providers.index --> "server/src/__tests__/routes/cli-keys.test" { resolveProvider }
    server.src.routes.health --> "server/src/__tests__/routes/cli-keys.test" { healthRouter }
    server.src.routes.keys --> "server/src/__tests__/routes/cli-keys.test" { keysRouter }
    server.src.routes.models --> "server/src/__tests__/routes/cli-keys.test" { modelsRouter }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/cli-keys.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/client-profiles.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/client-profiles.test" {
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/client-profiles.test" {
        mintDashboardToken,
    }
    server.src.routes.proxy --> "server/src/__tests__/routes/client-profiles.test" {
        clearReasoningMemory,
    }
    "server/src/services/context-handoff" --> "server/src/__tests__/routes/client-profiles.test" {
        _clearStoreForTesting,
    }
    server.src.app --> "server/src/__tests__/routes/codex-catalog.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/codex-catalog.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/codex-catalog.test" { encrypt }
    "server/src/services/codex-catalog" --> "server/src/__tests__/routes/codex-catalog.test" {
        buildCodexCatalog,
    }
    "server/src/services/codex-base-instructions" --> "server/src/__tests__/routes/codex-catalog.test" {
        CODEX_BASE_INSTRUCTIONS,
    }
    server.src.app --> "server/src/__tests__/routes/compression.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/compression.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
        setSetting,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/compression.test" {
        mintDashboardToken,
    }
    server.src.services.compression.stats --> "server/src/__tests__/routes/compression.test" {
        clearCompressionStats,
    }
    server.src.app --> "server/src/__tests__/routes/conversations.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/conversations.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/conversations.test" {
        mintDashboardToken,
    }
    server.src.routes.conversations --> "server/src/__tests__/routes/conversations.test" {
        MAX_MESSAGES_BYTES,
    }
    server.src.app --> "server/src/__tests__/routes/csp-inline-bootstrap.test" {
        INLINE_BOOTSTRAP_SHA,
        createApp,
    }
    server.src.db.index --> "server/src/__tests__/routes/csp-inline-bootstrap.test" { initDb }
    server.src.app --> "server/src/__tests__/routes/csp-security.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/csp-security.test" { initDb }
    server.src.lib.config --> "server/src/__tests__/routes/csp-security.test" { loadConfig }
    server.src.app --> "server/src/__tests__/routes/custom-endpoint-groups.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/custom-endpoint-groups.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    "server/src/services/model-groups" --> "server/src/__tests__/routes/custom-endpoint-groups.test" {
        getModelGroups,
        resolveRequestedIdToMembers,
    }
    "server/src/lib/endpoint-scope" --> "server/src/__tests__/routes/custom-endpoint-groups.test" {
        groupHandle,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/custom-endpoint-groups.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/custom-endpoint-identity.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/custom-endpoint-identity.test" {
        getDb,
        initDb,
    }
    server.src.services.router --> "server/src/__tests__/routes/custom-endpoint-identity.test" {
        getRoutingScores,
        refreshStatsCache,
        resetSpeedRankWriteback,
        resolveModelGroupCandidates,
        routePinnedModel,
        routeRequest,
        writeObservedSpeedRanks,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/custom-endpoint-identity.test" {
        clearCooldownsForKey,
        isOnCooldown,
        setCooldown,
    }
    "server/src/services/model-groups" --> "server/src/__tests__/routes/custom-endpoint-identity.test" {
        getModelGroups,
        resolveRequestedIdToMembers,
        setUnifyOverrides,
    }
    "server/src/lib/endpoint-scope" --> "server/src/__tests__/routes/custom-endpoint-identity.test" {
        endpointHandle,
        qualifiedModelMemberId,
    }
    "server/src/lib/request-log" --> "server/src/__tests__/routes/custom-endpoint-identity.test" {
        logRequest,
    }
    "server/src/services/model-listing" --> "server/src/__tests__/routes/custom-endpoint-identity.test" {
        buildModelListing,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/custom-endpoint-identity.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/custom-max-completion-tokens.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/custom-max-completion-tokens.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/custom-max-completion-tokens.test" {
        encrypt,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/routes/custom-max-completion-tokens.test" {
        stubPublicDns,
    }
    server.src.app --> "server/src/__tests__/routes/custom-modalities.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/custom-modalities.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/custom-modalities.test" { decrypt }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/custom-modalities.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/custom-model-discovery.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/custom-model-discovery.test" {
        getDb,
        initDb,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/custom-model-discovery.test" {
        isOnCooldown,
        setCooldown,
    }
    "server/src/services/model-discovery" --> "server/src/__tests__/routes/custom-model-discovery.test" {
        PROBE_MAX_TOKENS,
        REASONING_PROBE_MAX_TOKENS,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/custom-model-discovery.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/custom-model-kind-forwarding.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/custom-model-kind-forwarding.test" {
        getDb,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/custom-model-kind-forwarding.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/custom-provider-multikey.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/custom-provider-multikey.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/custom-provider-multikey.test" {
        decrypt,
    }
    server.src.services.router --> "server/src/__tests__/routes/custom-provider-multikey.test" {
        routePinnedModel,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/custom-provider-multikey.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.db.index --> "server/src/__tests__/routes/custom-provider-token-budget.test" {
        getDb,
        initDb,
    }
    server.src.routes.keys --> "server/src/__tests__/routes/custom-provider-token-budget.test" {
        keysRouter,
    }
    server.src.routes.models --> "server/src/__tests__/routes/custom-provider-token-budget.test" {
        modelsRouter,
    }
    server.src.routes.fallback --> "server/src/__tests__/routes/custom-provider-token-budget.test" {
        fallbackRouter,
    }
    server.src.app --> "server/src/__tests__/routes/custom-provider.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/custom-provider.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/custom-provider.test" { decrypt }
    server.src.services.router --> "server/src/__tests__/routes/custom-provider.test" {
        routeRequest,
    }
    server.src.providers.index --> "server/src/__tests__/routes/custom-provider.test" {
        getProvider,
        resolveProvider,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/custom-provider.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/custom-transcription.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/custom-transcription.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/custom-transcription.test" {
        clearCooldownsForKey,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/custom-transcription.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/decision-routing.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/decision-routing.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/decision-routing.test" { encrypt }
    server.src.services.ratelimit --> "server/src/__tests__/routes/decision-routing.test" {
        clearAllCooldowns,
    }
    "server/src/services/routing-decision" --> "server/src/__tests__/routes/decision-routing.test" {
        resetDecisionRoutingCache,
    }
    server.src.services.router --> "server/src/__tests__/routes/decision-routing.test" {
        refreshStatsCache,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/decision-routing.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    "server/src/__tests__/helpers/decision-models" --> "server/src/__tests__/routes/decision-routing.test" {
        seedDecisionModels,
    }
    server.src.db.index --> "server/src/__tests__/helpers/decision-models" { getDb }
    server.src.app --> "server/src/__tests__/routes/decisions-custom.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/decisions-custom.test" {
        getUnifiedApiKey,
        initDb,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/decisions-custom.test" {
        clearAllCooldowns,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/decisions-custom.test" {
        mintDashboardToken,
    }
    "server/src/__tests__/helpers/decision-models" --> "server/src/__tests__/routes/decisions-custom.test" {
        seedDecisionModels,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/routes/decisions-custom.test" {
        stubPublicDns,
    }
    server.src.app --> "server/src/__tests__/routes/decisions.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/decisions.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/decisions.test" { encrypt }
    server.src.services.ratelimit --> "server/src/__tests__/routes/decisions.test" {
        clearAllCooldowns,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/decisions.test" {
        mintDashboardToken,
    }
    "server/src/__tests__/helpers/decision-models" --> "server/src/__tests__/routes/decisions.test" {
        seedDecisionModels,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/routes/decisions.test" {
        stubPublicDns,
    }
    server.src.app --> "server/src/__tests__/routes/disabled-model-routing.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/disabled-model-routing.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/disabled-model-routing.test" { encrypt }
    server.src.services.router --> "server/src/__tests__/routes/disabled-model-routing.test" {
        getOrderedFusionChain,
        resolveRoutingChain,
        setRoutingStrategy,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/disabled-model-routing.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/docs.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/docs.test" { initDb }
    server.src.docs.openapi --> "server/src/__tests__/routes/docs.test" { openapiSpec }
    server.src.app --> "server/src/__tests__/routes/doubled-v1-prefix.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/doubled-v1-prefix.test" {
        getUnifiedApiKey,
        initDb,
    }
    server.src.app --> "server/src/__tests__/routes/embeddings-input-type.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/embeddings-input-type.test" {
        getDb,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/embeddings-input-type.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/embeddings-retry-after.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/embeddings-retry-after.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
        setSetting,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/embeddings-retry-after.test" { encrypt }
    server.src.services.ratelimit --> "server/src/__tests__/routes/embeddings-retry-after.test" {
        clearAllCooldowns,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/routes/embeddings-retry-after.test" {
        stubPublicDns,
    }
    server.src.app --> "server/src/__tests__/routes/embeddings-usage.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/embeddings-usage.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/embeddings-usage.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/emulation-handler-rejection.test";
    server.src.db.index --> "server/src/__tests__/routes/emulation-handler-rejection.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/emulation-handler-rejection.test";
    server.src.middleware.errorHandler --> "server/src/__tests__/routes/error-handler-security.test" {
        errorHandler,
    }
    server.src.app --> "server/src/__tests__/routes/fallback-detail-header.test";
    server.src.db.index --> "server/src/__tests__/routes/fallback-detail-header.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/fallback-detail-header.test";
    server.src.services.router --> "server/src/__tests__/routes/fallback-detail-header.test";
    "server/src/lib/fallback-loop" --> "server/src/__tests__/routes/fallback-detail-header.test";
    "server/src/lib/attempt-trace" --> "server/src/__tests__/routes/fallback-detail-header.test";
    server.src.app --> "server/src/__tests__/routes/fallback-hardening.test";
    server.src.db.index --> "server/src/__tests__/routes/fallback-hardening.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/fallback-hardening.test";
    server.src.services.router --> "server/src/__tests__/routes/fallback-hardening.test";
    "server/src/lib/fallback-loop" --> "server/src/__tests__/routes/fallback-hardening.test";
    server.src.app --> "server/src/__tests__/routes/fallback-keycount-parity.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/fallback-keycount-parity.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/fallback-keycount-parity.test" {
        encrypt,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/fallback-keycount-parity.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/fallback-pressure.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/fallback-pressure.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/fallback-pressure.test" { encrypt }
    server.src.services.router --> "server/src/__tests__/routes/fallback-pressure.test" {
        getAllPenalties,
        recordRateLimitHit,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/fallback-pressure.test" {
        getCooldownCeilingMs,
        getNextCooldownDuration,
        isOnCooldown,
        setCooldown,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/fallback-pressure.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/fallback-rate-limit-usage.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/fallback-rate-limit-usage.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/fallback-rate-limit-usage.test" {
        encrypt,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/fallback-rate-limit-usage.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/fallback.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/fallback.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/fallback.test" { encrypt }
    server.src.services.router --> "server/src/__tests__/routes/fallback.test" {
        recordRateLimitHit,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/fallback.test" { setCooldown }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/fallback.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/free-tier.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/free-tier.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/free-tier.test" { encrypt }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/free-tier.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/fusion.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/fusion.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/fusion.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.services.fusion --> "server/src/__tests__/routes/fusion.test" {
        diversifyChain,
        familyKey,
        fusionConfigSchema,
        isFusionModel,
    }
    server.src.services.router --> "server/src/__tests__/routes/fusion.test";
    server.src.services.router --> "server/src/__tests__/routes/fusion.test" {
        FusionCandidate,
        getOrderedFusionChain,
        getRoutingStrategy,
        setRoutingStrategy,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/fusion.test" {
        isOnCooldown,
        setCooldown,
    }
    server.src.app --> "server/src/__tests__/routes/gemini.test" { createApp }
    server.src.lib.crypto --> "server/src/__tests__/routes/gemini.test" { encrypt }
    server.src.db.index --> "server/src/__tests__/routes/gemini.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.db.index --> "server/src/__tests__/routes/health-quota-route.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/health-quota-route.test" { encrypt }
    server.src.middleware.requireAuth --> "server/src/__tests__/routes/health-quota-route.test" {
        requireAuth,
    }
    server.src.providers.index --> "server/src/__tests__/routes/health-quota-route.test" {
        resolveProvider,
    }
    server.src.routes.health --> "server/src/__tests__/routes/health-quota-route.test" {
        healthRouter,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/health-quota-route.test" {
        mintDashboardToken,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/routes/health-quota-route.test";
    server.src.app --> "server/src/__tests__/routes/key-monthly-budget.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/key-monthly-budget.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
        setSetting,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/key-monthly-budget.test" { encrypt }
    "server/src/services/key-budget" --> "server/src/__tests__/routes/key-monthly-budget.test" {
        nextMonthResetAt,
    }
    server.src.app --> "server/src/__tests__/routes/keys-cooldowns.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-cooldowns.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-cooldowns.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/keys-cooldowns.test" {
        isOnCooldown,
        setCooldown,
    }
    server.src.routes.keys --> "server/src/__tests__/routes/keys-desktop-reauth.test" { keysRouter }
    server.src.middleware.requireAuth --> "server/src/__tests__/routes/keys-desktop-reauth.test" {
        requireAuth,
    }
    server.src.db.index --> "server/src/__tests__/routes/keys-desktop-reauth.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-desktop-reauth.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-export-csv.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-export-csv.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-export-csv.test" {
        mintDashboardToken,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/keys-export-csv.test";
    server.src.app --> "server/src/__tests__/routes/keys-export-custom-roundtrip.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-export-custom-roundtrip.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/keys-export-custom-roundtrip.test" {
        decrypt,
        encrypt,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-export-custom-roundtrip.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-export-env-label.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-export-env-label.test" {
        getDb,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-export-env-label.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-export-password.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-export-password.test" {
        getDb,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-export-password.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-import-models.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-import-models.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-import-models.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-import-selected-custom.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-import-selected-custom.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/keys-import-selected-custom.test" {
        encrypt,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-import-selected-custom.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-llmtr-unchecked.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-llmtr-unchecked.test" {
        getDb,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-llmtr-unchecked.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    "server/src/db/migrations/20261017_000001_llmtr_reenable_keys" --> "server/src/__tests__/routes/keys-llmtr-unchecked.test" {
        down,
        up,
    }
    server.src.app --> "server/src/__tests__/routes/keys-model-scope.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-model-scope.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/keys-model-scope.test" { encrypt }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-model-scope.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-monthly-usage.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-monthly-usage.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-monthly-usage.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-providers-checklist.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-providers-checklist.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/keys-providers-checklist.test" {
        encrypt,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-providers-checklist.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-proxy.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-proxy.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/keys-proxy.test" { encrypt }
    "server/src/lib/key-proxy" --> "server/src/__tests__/routes/keys-proxy.test" { decryptProxyUrl }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-proxy.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-reveal.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-reveal.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-reveal.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys-ssrf-guard.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys-ssrf-guard.test" { getDb, initDb }
    server.src.lib.proxy --> "server/src/__tests__/routes/keys-ssrf-guard.test" { proxyFetch }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys-ssrf-guard.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/keys.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/keys.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/keys.test" { decrypt }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/keys.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/logs.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/logs.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/logs.test" {
        mintDashboardToken,
    }
    "server/src/lib/server-logs" --> "server/src/__tests__/routes/logs.test" {
        RING_CAPACITY,
        clearLogs,
        currentMaxId,
        initServerLogs,
        providerLog,
        recordLogEntry,
        resetServerLogsForTest,
        ringSnapshot,
    }
    "server/src/lib/log-redaction" --> "server/src/__tests__/routes/logs.test" {
        installLogRedaction,
    }
    "server/src/services/request-retention" --> "server/src/__tests__/routes/logs.test" {
        getServerLogRetentionConfig,
        pruneServerLogs,
    }
    server.src.app --> "server/src/__tests__/routes/mcp-framing.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/mcp-framing.test" {
        getUnifiedApiKey,
        initDb,
        setSetting,
    }
    server.src.app --> "server/src/__tests__/routes/mcp.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/mcp.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
        setSetting,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/mcp.test" { encrypt }
    server.src.app --> "server/src/__tests__/routes/media-retry-after.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/media-retry-after.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/media-retry-after.test" { encrypt }
    server.src.app --> "server/src/__tests__/routes/media-transcription-dashboard.test" {
        createApp,
    }
    server.src.db.index --> "server/src/__tests__/routes/media-transcription-dashboard.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/media-transcription-dashboard.test" {
        encrypt,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/media-transcription-dashboard.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/media-usage.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/media-usage.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/media-usage.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    "server/src/services/custom-endpoint" --> "server/src/__tests__/routes/media-usage.test" {
        resolveCustomEndpointKey,
    }
    "server/src/services/custom-media-register" --> "server/src/__tests__/routes/media-usage.test" {
        registerCustomMediaModel,
    }
    server.src.services.media --> "server/src/__tests__/routes/media-usage.test" {
        runImageGeneration,
    }
    server.src.app --> "server/src/__tests__/routes/models-management.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/models-management.test" {
        getDb,
        getSetting,
        getUnifiedApiKey,
        initDb,
        setSetting,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/models-management.test" { encrypt }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/models-management.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    "server/src/services/model-state" --> "server/src/__tests__/routes/models-management.test" {
        applyAllModelOverrides,
    }
    server.src.app --> "server/src/__tests__/routes/models-provider-actions.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/models-provider-actions.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/models-provider-actions.test" { encrypt }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/models-provider-actions.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.providers.index --> "server/src/__tests__/routes/models-provider-actions.test" {
        getProvider,
    }
    "server/src/services/model-state" --> "server/src/__tests__/routes/models-provider-actions.test" {
        getCatalogModelTombstone,
    }
    server.src.app --> "server/src/__tests__/routes/models-retrieve.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/models-retrieve.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/models-retrieve.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/models-test-budget.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/models-test-budget.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/models-test-budget.test" { encrypt }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/models-test-budget.test" {
        mintDashboardToken,
    }
    server.src.providers.index --> "server/src/__tests__/routes/models-test-budget.test" {
        getProvider,
    }
    "server/src/services/key-budget" --> "server/src/__tests__/routes/models-test-budget.test" {
        checkMonthlyBudget,
        getMonthlyUsage,
    }
    server.src.app --> "server/src/__tests__/routes/moderation.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/moderation.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/moderation.test" { encrypt }
    server.src.services.moderation --> "server/src/__tests__/routes/moderation.test" {
        listModerationModels,
        resolveModel,
    }
    server.src.services.health --> "server/src/__tests__/routes/moderation.test" {
        clearLastHealthyStampState,
    }
    server.src.app --> "server/src/__tests__/routes/non-chat-provider-routing.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/non-chat-provider-routing.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/non-chat-provider-routing.test" {
        encrypt,
    }
    server.src.services.router --> "server/src/__tests__/routes/non-chat-provider-routing.test" {
        routeRequest,
    }
    server.src.providers.index --> "server/src/__tests__/routes/non-chat-provider-routing.test" {
        getProvider,
    }
    server.src.app --> "server/src/__tests__/routes/ollama.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/ollama.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
        setSetting,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/ollama.test" { encrypt }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/ollama.test" {
        mintDashboardToken,
    }
    server.src.routes.ollama --> "server/src/__tests__/routes/ollama.test" { isLoopback }
    server.src.lib.guardrails --> "server/src/__tests__/routes/ollama.test" {
        REQUEST_MAX_TOKENS_BUDGET_SETTING,
    }
    server.src.app --> "server/src/__tests__/routes/output-cap-learning.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/output-cap-learning.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/output-cap-learning.test" { encrypt }
    "server/src/lib/output-cap" --> "server/src/__tests__/routes/output-cap-learning.test" {
        resetLearnedOutputCaps,
    }
    server.src.providers.index --> "server/src/__tests__/routes/output-cap-learning.test" {
        getProvider,
    }
    server.src.services.router --> "server/src/__tests__/routes/output-cap-learning.test" {
        setRoutingStrategy,
    }
    server.src.app --> "server/src/__tests__/routes/profiles-chains.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/profiles-chains.test" { getDb, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/profiles-chains.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    "server/src/services/profile-models" --> "server/src/__tests__/routes/profiles-chains.test" {
        ensureAllModelsInProfiles,
        ensureModelInProfiles,
    }
    server.src.services.router --> "server/src/__tests__/routes/profiles-chains.test" {
        resolveRoutingChain,
    }
    server.src.app --> "server/src/__tests__/routes/provider-reported-size.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/provider-reported-size.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/provider-reported-size.test" { encrypt }
    server.src.providers.index --> "server/src/__tests__/routes/provider-reported-size.test" {
        getProvider,
    }
    server.src.services.router --> "server/src/__tests__/routes/provider-reported-size.test" {
        setRoutingStrategy,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-array-content.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-array-content.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-array-content.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-auth-cors.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-auth-cors.test" {
        getUnifiedApiKey,
        initDb,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-auth-rotation.test";
    server.src.db.index --> "server/src/__tests__/routes/proxy-auth-rotation.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/proxy-auth-rotation.test";
    server.src.services.router --> "server/src/__tests__/routes/proxy-auth-rotation.test";
    server.src.app --> "server/src/__tests__/routes/proxy-auto-model.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-auto-model.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-auto-model.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-cache.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-cache.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.services.cache --> "server/src/__tests__/routes/proxy-cache.test" { clearCache }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-cache.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-completions.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-completions.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/proxy-completions.test" { encrypt }
    server.src.services.router --> "server/src/__tests__/routes/proxy-completions.test" {
        setRoutingStrategy,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-empty-completion.test";
    server.src.db.index --> "server/src/__tests__/routes/proxy-empty-completion.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/proxy-empty-completion.test";
    server.src.services.router --> "server/src/__tests__/routes/proxy-empty-completion.test";
    server.src.app --> "server/src/__tests__/routes/proxy-error-redaction.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-error-redaction.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-error-redaction.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-execution-id.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-execution-id.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-execution-id.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-max-tokens-routing.test";
    server.src.db.index --> "server/src/__tests__/routes/proxy-max-tokens-routing.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/proxy-max-tokens-routing.test";
    server.src.services.router --> "server/src/__tests__/routes/proxy-max-tokens-routing.test";
    server.src.app --> "server/src/__tests__/routes/proxy-model-groups.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-model-groups.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/proxy-model-groups.test" { encrypt }
    "server/src/services/model-groups" --> "server/src/__tests__/routes/proxy-model-groups.test" {
        setUnifyEnabled,
        setUnifyOverrides,
    }
    server.src.services.router --> "server/src/__tests__/routes/proxy-model-groups.test" {
        setRoutingStrategy,
    }
    server.src.services.compression.config --> "server/src/__tests__/routes/proxy-model-groups.test" {
        setCompressionConfig,
    }
    "server/src/services/context-handoff" --> "server/src/__tests__/routes/proxy-model-groups.test" {
        _clearStoreForTesting,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-model-groups.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-moonshot-partial.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-moonshot-partial.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-moonshot-partial.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-multikey-penalty.test";
    server.src.db.index --> "server/src/__tests__/routes/proxy-multikey-penalty.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/proxy-multikey-penalty.test";
    server.src.services.router --> "server/src/__tests__/routes/proxy-multikey-penalty.test";
    server.src.services.ratelimit --> "server/src/__tests__/routes/proxy-multikey-penalty.test";
    server.src.app --> "server/src/__tests__/routes/proxy-pinned-model.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-pinned-model.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-pinned-model.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-provider-level-skip.test";
    server.src.db.index --> "server/src/__tests__/routes/proxy-provider-level-skip.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/proxy-provider-level-skip.test";
    server.src.services.router --> "server/src/__tests__/routes/proxy-provider-level-skip.test";
    server.src.app --> "server/src/__tests__/routes/proxy-rate-limit.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-rate-limit.test" { initDb }
    server.src.routes.proxy --> "server/src/__tests__/routes/proxy-retry.test" {
        isModelAccessForbiddenError,
        isModelNotFoundError,
        isPaymentRequiredError,
        isRetryableError,
    }
    "server/src/lib/error-classify" --> "server/src/__tests__/routes/proxy-retry.test" {
        isProviderBadRequestError,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/routes/proxy-retry.test" {
        classifyAttemptError,
        cooldownDecisionForError,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/proxy-retry.test" {
        MODEL_FORBIDDEN_COOLDOWN_MS,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-served-model.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-served-model.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    "server/src/lib/served-model" --> "server/src/__tests__/routes/proxy-served-model.test" {
        resetServedModelObservations,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-served-model.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.routes.proxy --> "server/src/__tests__/routes/proxy-stream-chunk.test" {
        streamChunkText,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-stream-integrity.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-stream-integrity.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.routes.proxy --> "server/src/__tests__/routes/proxy-stream-integrity.test" {
        getStickyModel,
        setStickyModel,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-stream-integrity.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-stream-keepalive.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-stream-keepalive.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-stream-keepalive.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-stream-usage.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-stream-usage.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-stream-usage.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-tools-routing.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-tools-routing.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.services.router --> "server/src/__tests__/routes/proxy-tools-routing.test" {
        routeRequest,
        setRoutingStrategy,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/proxy-tools-routing.test" { encrypt }
    server.src.app --> "server/src/__tests__/routes/proxy-tools.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-tools.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/proxy-tools.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.routes.proxy --> "server/src/__tests__/routes/proxy-tools.test" {
        clearReasoningMemory,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-usage.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-usage.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/proxy-usage.test" { encrypt }
    "server/src/lib/system-prompt" --> "server/src/__tests__/routes/proxy-usage.test" {
        hashClientProfileKey,
    }
    server.src.app --> "server/src/__tests__/routes/proxy-vision.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/proxy-vision.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.app --> "server/src/__tests__/routes/quota-outlook.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/quota-outlook.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/quota-outlook.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/reasoning-control.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/reasoning-control.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/reasoning-control.test" {
        mintDashboardToken,
    }
    server.src.routes.anthropic --> "server/src/__tests__/routes/reasoning-control.test" {
        effortFromAnthropicThinking,
    }
    server.src.app --> "server/src/__tests__/routes/reasoning-only-failover.test";
    server.src.db.index --> "server/src/__tests__/routes/reasoning-only-failover.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/reasoning-only-failover.test";
    server.src.services.router --> "server/src/__tests__/routes/reasoning-only-failover.test";
    "server/src/lib/tool-validate" --> "server/src/__tests__/routes/reasoning-only-failover.test";
    server.src.app --> "server/src/__tests__/routes/rescue-wants-tools.test";
    server.src.db.index --> "server/src/__tests__/routes/rescue-wants-tools.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/rescue-wants-tools.test";
    server.src.services.router --> "server/src/__tests__/routes/rescue-wants-tools.test";
    server.src.app --> "server/src/__tests__/routes/responses-fallback-convergence.test" {
        createApp,
    }
    server.src.db.index --> "server/src/__tests__/routes/responses-fallback-convergence.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.app --> "server/src/__tests__/routes/responses-fusion.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/responses-fusion.test" {
        getUnifiedApiKey,
        initDb,
    }
    server.src.app --> "server/src/__tests__/routes/responses-tool-args-repair.test";
    server.src.db.index --> "server/src/__tests__/routes/responses-tool-args-repair.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/responses-tool-args-repair.test";
    server.src.services.router --> "server/src/__tests__/routes/responses-tool-args-repair.test";
    server.src.routes.responses --> "server/src/__tests__/routes/responses-translate.test" {
        buildResponseObject,
        responsesInputHasFileIdImage,
        responsesInputRequestsComputerUse,
        toChatMessages,
        toChatToolChoice,
        toChatTools,
    }
    server.src.app --> "server/src/__tests__/routes/responses.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/responses.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.routes.proxy --> "server/src/__tests__/routes/responses.test" { setStickyModel }
    server.src.app --> "server/src/__tests__/routes/routed-via-header.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/routed-via-header.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/routed-via-header.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/routing-semantics.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/routing-semantics.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/routes/routing-semantics.test" { encrypt }
    server.src.services.router --> "server/src/__tests__/routes/routing-semantics.test" {
        resolveModelGroupCandidates,
        resolveRoutingChain,
        routeRequest,
        setKeySelectionStrategy,
        setRoutingStrategy,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/routes/routing-semantics.test" {
        recordQuotaObservation,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/routing-semantics.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/search.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/search.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
        setSetting,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/search.test" { encrypt }
    server.src.services.ratelimit --> "server/src/__tests__/routes/search.test" {
        clearAllCooldowns,
        setCooldown,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/search.test" {
        mintDashboardToken,
    }
    "server/src/__tests__/helpers/search-engines" --> "server/src/__tests__/routes/search.test" {
        seedSearchEngines,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/routes/search.test" { stubPublicDns }
    server.src.app --> "server/src/__tests__/routes/settings-headroom.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/settings-headroom.test" {
        getSetting,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/settings-headroom.test" {
        mintDashboardToken,
    }
    server.src.services.router --> "server/src/__tests__/routes/settings-headroom.test" {
        HEADROOM_FLOOR_KEY,
        HEADROOM_RAMP_START_KEY,
    }
    server.src.app --> "server/src/__tests__/routes/settings-mcp.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/settings-mcp.test" {
        getSetting,
        getUnifiedApiKey,
        initDb,
    }
    "server/src/db/migrations/20260903_000001_mcp_enabled_default" --> "server/src/__tests__/routes/settings-mcp.test" {
        up,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/settings-mcp.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/settings-min-reliability-floor.test" {
        createApp,
    }
    server.src.db.index --> "server/src/__tests__/routes/settings-min-reliability-floor.test" {
        getSetting,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/settings-min-reliability-floor.test" {
        mintDashboardToken,
    }
    server.src.services.router --> "server/src/__tests__/routes/settings-min-reliability-floor.test" {
        MIN_RELIABILITY_FLOOR_KEY,
    }
    server.src.app --> "server/src/__tests__/routes/settings-output-limit.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/settings-output-limit.test" {
        getSetting,
        initDb,
        setSetting,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/settings-output-limit.test" {
        mintDashboardToken,
    }
    "server/src/lib/sampling-params" --> "server/src/__tests__/routes/settings-output-limit.test" {
        UNIFIED_MAX_TOKENS_AUTO,
        UNIFIED_MAX_TOKENS_SETTING,
    }
    server.src.app --> "server/src/__tests__/routes/settings-provider-moment-attribution.test" {
        createApp,
    }
    server.src.db.index --> "server/src/__tests__/routes/settings-provider-moment-attribution.test" {
        getDb,
        getSetting,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/settings-provider-moment-attribution.test" {
        mintDashboardToken,
    }
    server.src.services.router --> "server/src/__tests__/routes/settings-provider-moment-attribution.test" {
        PROVIDER_MOMENT_ATTRIBUTION_KEY,
    }
    server.src.app --> "server/src/__tests__/routes/settings-proxy.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/settings-proxy.test" { getSetting, initDb }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/settings-proxy.test" {
        mintDashboardToken,
    }
    server.src.lib.proxy --> "server/src/__tests__/routes/settings-proxy.test" {
        applyFetchRelayToken,
        applyProxyMode,
        applyProxyUrl,
    }
    server.src.app --> "server/src/__tests__/routes/settings-task-weight-share.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/settings-task-weight-share.test";
    server.src.db.index --> "server/src/__tests__/routes/settings-task-weight-share.test" {
        getSetting,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/settings-task-weight-share.test" {
        mintDashboardToken,
    }
    server.src.services.router --> "server/src/__tests__/routes/settings-task-weight-share.test" {
        TASK_WEIGHT_SHARE_KEY,
        getTaskWeightShare,
        setTaskWeightShare,
    }
    server.src.services.scoring --> "server/src/__tests__/routes/settings-task-weight-share.test" {
        TASK_WEIGHT_SHARE,
        taskAdjustedWeights,
    }
    server.src.app --> "server/src/__tests__/routes/specialist-text.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/specialist-text.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/routes/specialist-text.test" {
        applyCatalog,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/routes/specialist-text.test" {
        autoRegistrable,
    }
    "server/src/services/specialist-text" --> "server/src/__tests__/routes/specialist-text.test" {
        listSpecialists,
    }
    server.src.app --> "server/src/__tests__/routes/static-assets-caching.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/static-assets-caching.test" { initDb }
    server.src.app --> "server/src/__tests__/routes/static-client.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/static-client.test" { initDb }
    server.src.app --> "server/src/__tests__/routes/status.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/status.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/status.test" { encrypt }
    server.src.app --> "server/src/__tests__/routes/system-date.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/system-date.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/system-date.test" { encrypt }
    "server/src/lib/system-prompt" --> "server/src/__tests__/routes/system-date.test" {
        hashClientProfileKey,
        mintClientProfileKey,
    }
    "server/src/lib/system-date" --> "server/src/__tests__/routes/system-date.test" {
        setSystemDateMode,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/system-date.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/tool-rejection-e2e-1230.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/tool-rejection-e2e-1230.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.services.router --> "server/src/__tests__/routes/tool-rejection-e2e-1230.test" {
        setExploreEnabled,
        setRoutingStrategy,
    }
    "server/src/lib/tool-capability" --> "server/src/__tests__/routes/tool-rejection-e2e-1230.test" {
        resetToolCapability,
    }
    server.src.services.ratelimit --> "server/src/__tests__/routes/tool-rejection-e2e-1230.test" {
        clearCooldownsForKey,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/tool-rejection-e2e-1230.test" {
        mintDashboardToken,
    }
    server.src.__tests__.helpers.chain --> "server/src/__tests__/routes/tool-rejection-e2e-1230.test" {
        addToActiveChain,
    }
    server.src.app --> "server/src/__tests__/routes/tool-validate-surfaces.test";
    server.src.db.index --> "server/src/__tests__/routes/tool-validate-surfaces.test";
    server.src.lib.crypto --> "server/src/__tests__/routes/tool-validate-surfaces.test";
    server.src.services.router --> "server/src/__tests__/routes/tool-validate-surfaces.test";
    server.src.app --> "server/src/__tests__/routes/update-release.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/update-release.test" {
        getSetting,
        initDb,
        setSetting,
    }
    server.src.routes.update --> "server/src/__tests__/routes/update-release.test" {
        UPDATE_CHECK_SETTING,
        createUpdateRouter,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/update-release.test" {
        mintDashboardToken,
    }
    server.src.routes.update --> "server/src/__tests__/routes/update.test" { createUpdateRouter }
    server.src.app --> "server/src/__tests__/routes/url-tokens.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/url-tokens.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/url-tokens.test" { encrypt }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/routes/url-tokens.test" {
        mintDashboardToken,
    }
    server.src.app --> "server/src/__tests__/routes/video-generations.test" { createApp }
    server.src.db.index --> "server/src/__tests__/routes/video-generations.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/routes/video-generations.test" { encrypt }
    server.src.db.index --> "server/src/__tests__/scripts/rotate-encryption-key-cli.test" { initDb }
    "server/src/scripts/rotate-encryption-key" --> "server/src/__tests__/scripts/rotate-encryption-key-cli.test" {
        decryptWith,
        encryptWith,
    }
    server.src.db.index --> "server/src/__tests__/scripts/rotate-encryption-key.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/scripts/rotate-encryption-key.test" {
        decrypt,
        encrypt,
    }
    "server/src/scripts/rotate-encryption-key" --> "server/src/__tests__/scripts/rotate-encryption-key.test" {
        applyRotation,
        decryptWith,
        encryptWith,
        rotateSecrets,
    }
    "server/src/services/model-listing" --> "server/src/__tests__/services/advertised-context-window.test" {
        advertisedContextWindow,
    }
    server.src.services.router --> "server/src/__tests__/services/advertised-context-window.test" {
        CONTEXT_WINDOW_SAFETY_FACTOR,
        fitsContextWindow,
    }
    "server/src/services/anthropic-map" --> "server/src/__tests__/services/anthropic-map.test" {
        classifyClaudeFamily,
        parseTierSelector,
        resolveAnthropicModel,
        setClaudeModelMap,
    }
    server.src.db.index --> "server/src/__tests__/services/anthropic-map.test" { getDb, initDb }
    server.src.db.index --> "server/src/__tests__/services/apinex.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/apinex.test" { encrypt }
    server.src.services.decision --> "server/src/__tests__/services/apinex.test" {
        DECISION_PLATFORMS,
        runDecision,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/apinex.test" {
        clearAllCooldowns,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/apinex.test" {
        applyCatalog,
        catalogShapeProblems,
    }
    server.src.providers.apinex --> "server/src/__tests__/services/apinex.test" { ApinexProvider }
    server.src.db.index --> "server/src/__tests__/services/backup-auto-retention.test" {
        getDb,
        initDb,
    }
    server.src.services.backups --> "server/src/__tests__/services/backup-auto-retention.test" {
        createBackup,
        getAutoDumpRetention,
        pruneAutoDumps,
    }
    server.src.db.index --> "server/src/__tests__/services/backup-scheduler-local-day.test" {
        getDb,
        getSetting,
        initDb,
        setSetting,
    }
    server.src.lib.scheduler --> "server/src/__tests__/services/backup-scheduler-local-day.test" {
        NodeScheduler,
    }
    server.src.services.backups --> "server/src/__tests__/services/backup-scheduler-local-day.test" {
        startBackupScheduler,
        writeBackupSchedule,
    }
    server.src.db.index --> "server/src/__tests__/services/beatapi-serpsearch.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/beatapi-serpsearch.test" { encrypt }
    server.src.services.decision --> "server/src/__tests__/services/beatapi-serpsearch.test" {
        DECISION_PLATFORMS,
        runDecision,
    }
    server.src.services.search --> "server/src/__tests__/services/beatapi-serpsearch.test" {
        SEARCH_ENGINE_PLATFORMS,
        runSearch,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/beatapi-serpsearch.test" {
        clearAllCooldowns,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/beatapi-serpsearch.test" {
        applyCatalog,
    }
    server.src.services.health --> "server/src/__tests__/services/beatapi-serpsearch.test" {
        checkAllKeys,
        checkKeyHealth,
        probeKeyValidity,
    }
    server.src.db.index --> "server/src/__tests__/services/budget-alerts.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/budget-alerts.test" { encrypt }
    "server/src/lib/request-log" --> "server/src/__tests__/services/budget-alerts.test" {
        logRequest,
    }
    "server/src/lib/server-logs" --> "server/src/__tests__/services/budget-alerts.test" {
        clearLogs,
        ringSnapshot,
    }
    "server/src/services/key-budget" --> "server/src/__tests__/services/budget-alerts.test" {
        setMonthlyBudgetCaps,
    }
    "server/src/services/budget-alerts" --> "server/src/__tests__/services/budget-alerts.test" {
        budgetAlertWebhookUrl,
        budgetThresholdCrossings,
        budgetWebhookPayload,
        firedBudgetAlerts,
        noteBudgetAlerts,
    }
    server.src.db.index --> "server/src/__tests__/services/builtin-model-discovery.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/builtin-model-discovery.test" {
        encrypt,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/services/builtin-model-discovery.test" {
        BUILTIN_DISCOVERY_PLATFORMS,
        autoRegistrable,
        builtinDiscoveryEligibility,
        builtinDiscoveryMode,
        registerDiscoveredModels,
        resetBuiltinDiscoveryThrottle,
        runBuiltinModelDiscovery,
        triggerBuiltinModelDiscovery,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/builtin-model-discovery.test" {
        applyCatalog,
    }
    "server/src/services/model-state" --> "server/src/__tests__/services/builtin-model-discovery.test" {
        isCatalogManagedModel,
        recordCatalogModelTombstone,
    }
    server.src.db.index --> "server/src/__tests__/services/cache.test" { getDb, initDb, setSetting }
    server.src.services.cache --> "server/src/__tests__/services/cache.test" {
        CACHE_ENABLED_SETTING,
        STREAM_CACHE_MAX_BYTES,
        __flushPersistenceForTests,
        __resetMemoryForTests,
        cacheActive,
        clearCache,
        computeCacheKey,
        getCacheStats,
        getCachedResponse,
        getCachedStreamResponse,
        isCacheEnabled,
        isCacheableTemperature,
        loadCacheFromDb,
        parseCacheDirective,
        storeCachedResponse,
        storeCachedStreamResponse,
    }
    server.src.lib.proxy --> "server/src/__tests__/services/cartesia-ink2.test";
    "server/src/services/media-voice-gateways" --> "server/src/__tests__/services/cartesia-ink2.test" {
        CARTESIA_VERSION,
        cartesiaTranscription,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/catalog-fallback-fetch.test" {
        catalogFetch,
        setCatalogFallbackFetch,
        validateLicenseKey,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/catalog-shape.test" {
        catalogShapeProblems,
    }
    server.src.db.index --> "server/src/__tests__/services/catalog-sync-scheduler.test" { initDb }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/catalog-sync-scheduler.test" {
        startCatalogSync,
        stopCatalogSync,
    }
    server.src.lib.scheduler --> "server/src/__tests__/services/catalog-sync-scheduler.test" {
        Scheduler,
    }
    server.src.app --> "server/src/__tests__/services/catalog-sync-source.test" { createApp }
    server.src.db.index --> "server/src/__tests__/services/catalog-sync-source.test" {
        getDb,
        initDb,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/catalog-sync-source.test" {
        applyCatalog,
    }
    "server/src/services/declarative-config" --> "server/src/__tests__/services/catalog-sync-source.test" {
        applyDeclarativeConfig,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/services/catalog-sync-source.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.db.index --> "server/src/__tests__/services/catalog-sync.test" {
        getDb,
        getSetting,
        initDb,
        setSetting,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/catalog-sync.test" {
        MIN_CATALOG_VERSION,
        applyCatalog,
        reapplyCachedCatalog,
    }
    server.src.db.migrate.runner --> "server/src/__tests__/services/catalog-sync.test" {
        runMigrationsSync,
    }
    "server/src/services/model-state" --> "server/src/__tests__/services/catalog-sync.test" {
        getCatalogModelTombstone,
        recordCatalogModelTombstone,
        retireCatalogModelUpstream,
        upsertModelOverrides,
    }
    server.src.app --> "server/src/__tests__/services/cloudflare-daily-quota.test" { createApp }
    server.src.db.index --> "server/src/__tests__/services/cloudflare-daily-quota.test" {
        getDb,
        getUnifiedApiKey,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/cloudflare-daily-quota.test" {
        encrypt,
    }
    "server/src/services/cloudflare-daily-quota" --> "server/src/__tests__/services/cloudflare-daily-quota.test" {
        benchCloudflareAccount,
        cloudflareAccountId,
        isCloudflareNeuronsExhausted,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/cloudflare-daily-quota.test" {
        clearAllCooldowns,
        clearCooldownsForKey,
        getActiveCooldownsForKeys,
        isOnCooldown,
    }
    server.src.db.index --> "server/src/__tests__/services/cloudflare-neurons.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/cloudflare-neurons.test" { encrypt }
    server.src.providers.cloudflare --> "server/src/__tests__/services/cloudflare-neurons.test" {
        CloudflareProvider,
    }
    "server/src/services/cloudflare-neurons" --> "server/src/__tests__/services/cloudflare-neurons.test" {
        CloudflareNeuronCapError,
        DEFAULT_CLOUDFLARE_DAILY_NEURON_CAP,
        cloudflareNeuronsAvailable,
        cloudflareNeuronsUsedToday,
        localNeuronsToday,
        meterCloudflare,
        neuronsFor,
        refreshRemoteNeurons,
        resetCloudflareNeuronMeter,
        startCloudflareCall,
    }
    "server/src/services/cloudflare-daily-quota" --> "server/src/__tests__/services/cloudflare-neurons.test" {
        isCloudflareNeuronsExhausted,
    }
    "server/src/services/provider-credential" --> "server/src/__tests__/services/cloudflare-neurons.test" {
        reserveProviderCredential,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/cloudflare-neurons.test" {
        clearAllCooldowns,
        isOnCooldown,
    }
    server.src.db.index --> "server/src/__tests__/services/compression.test" { initDb }
    server.src.services.compression.config --> "server/src/__tests__/services/compression.test" {
        DEFAULT_COMPRESSION_CONFIG,
        getCompressionConfig,
        parseCompressionDirective,
        resolveCompressionMode,
        setCompressionConfig,
    }
    "server/src/services/compression/fidelity-gate" --> "server/src/__tests__/services/compression.test" {
        checkFidelity,
    }
    server.src.services.compression.preservation --> "server/src/__tests__/services/compression.test" {
        extractProtectedValues,
        hasProtectedSpan,
        mergeProtectedSpans,
        scanProtectedSpans,
    }
    server.src.services.compression.pipeline --> "server/src/__tests__/services/compression.test" {
        _clearPrefixFreezeForTesting,
        compressRequest,
    }
    server.src.services.compression.engines.jsoncompact --> "server/src/__tests__/services/compression.test" {
        decodeJsonTables,
        encodeJsonTable,
    }
    server.src.services.compression.stats --> "server/src/__tests__/services/compression.test" {
        clearCompressionStats,
        getCompressionStats,
    }
    server.src.services.compression.types --> "server/src/__tests__/services/compression.test" {
        CompressionConfig,
        CompressionMode,
    }
    server.src.services.cache --> "server/src/__tests__/services/compression.test" {
        computeCacheKey,
    }
    "server/src/services/context-handoff" --> "server/src/__tests__/services/context-handoff.test" {
        HANDOFF_MAX_TOKENS,
        _clearStoreForTesting,
        getContextHandoffMode,
        hasPriorModel,
        maybeInjectContextHandoff,
        recordIncomingMessages,
        recordSuccessfulModel,
    }
    server.src.db.index --> "server/src/__tests__/services/cooldown-probe.test" { getDb, initDb }
    server.src.services.ratelimit --> "server/src/__tests__/services/cooldown-probe.test" {
        getProbeableCooldowns,
        isOnCooldown,
        setCooldown,
    }
    "server/src/services/cooldown-probe" --> "server/src/__tests__/services/cooldown-probe.test" {
        resetCooldownProbeState,
        runCooldownProbePass,
        startCooldownProbe,
        stopCooldownProbe,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/services/cooldown-probe.test" {
        cooldownDecisionForError,
    }
    server.src.services.router --> "server/src/__tests__/services/cooldown-probe.test" {
        RouteResult,
    }
    server.src.services.health --> "server/src/__tests__/services/cooldown-probe.test" {
        KeyProbeOutcome,
    }
    server.src.lib.scheduler --> "server/src/services/cooldown-probe" { Scheduler }
    server.src.services.ratelimit --> "server/src/services/cooldown-probe" {
        ProbeableCooldown,
        clearCooldownEarly,
        getProbeableCooldowns,
    }
    server.src.services.health --> "server/src/services/cooldown-probe" {
        KeyProbeOutcome,
        probeKeyValidity,
    }
    "server/src/lib/server-logs" --> "server/src/services/cooldown-probe" { providerLog }
    server.src.db.index --> "server/src/__tests__/services/custom-model-seed.test" { getDb, initDb }
    "server/src/services/custom-model-seed" --> "server/src/__tests__/services/custom-model-seed.test" {
        FALLBACK_CUSTOM_SEED,
        customModelSeed,
    }
    server.src.db.index --> "server/src/__tests__/services/custom-model-sync.test" { getDb, initDb }
    "server/src/services/custom-model-sync" --> "server/src/__tests__/services/custom-model-sync.test" {
        customModelSyncFreePatterns,
        customModelSyncIntervalMs,
        runCustomModelSync,
        startCustomModelSync,
    }
    "server/src/services/model-discovery" --> "server/src/__tests__/services/custom-model-sync.test" {
        discoverEndpointModels,
    }
    "server/src/services/custom-model-register" --> "server/src/__tests__/services/custom-model-sync.test" {
        registerCustomModels,
    }
    "server/src/services/custom-model-tombstone" --> "server/src/__tests__/services/custom-model-sync.test" {
        recordCustomModelTombstone,
    }
    "server/src/lib/endpoint-scope" --> "server/src/__tests__/services/custom-model-sync.test" {
        endpointScopeForBaseUrl,
    }
    server.src.db.index --> "server/src/__tests__/services/decision-spend-ledger.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/decision-spend-ledger.test" { encrypt }
    server.src.services.ratelimit --> "server/src/__tests__/services/decision-spend-ledger.test" {
        clearAllCooldowns,
    }
    server.src.services.decision --> "server/src/__tests__/services/decision-spend-ledger.test" {
        DecisionError,
        runDecision,
    }
    "server/src/services/key-budget" --> "server/src/__tests__/services/decision-spend-ledger.test" {
        getMonthlyUsage,
    }
    "server/src/__tests__/helpers/decision-models" --> "server/src/__tests__/services/decision-spend-ledger.test" {
        seedDecisionModels,
    }
    "server/src/lib/server-logs" --> "server/src/__tests__/services/decision-spend-ledger.test" {
        clearLogs,
        ringSnapshot,
    }
    server.src.db.index --> "server/src/__tests__/services/decision.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/decision.test" { encrypt }
    server.src.services.ratelimit --> "server/src/__tests__/services/decision.test" {
        clearAllCooldowns,
        isOnCooldown,
    }
    server.src.services.decision --> "server/src/__tests__/services/decision.test" {
        CATALOG_DECISION_PLATFORMS,
        DECISION_PLATFORMS,
        DecisionError,
        decisionsAvailable,
        listDecisionModels,
        runDecision,
        setDecisionModelEnabled,
    }
    server.src.services.media --> "server/src/__tests__/services/decision.test" {
        listAllMediaModels,
    }
    "server/src/__tests__/helpers/decision-models" --> "server/src/__tests__/services/decision.test" {
        seedDecisionModels,
    }
    server.src.db.index --> "server/src/__tests__/services/declarative-config-profiles.test" {
        getDb,
        initDb,
    }
    "server/src/services/declarative-config" --> "server/src/__tests__/services/declarative-config-profiles.test" {
        applyDeclarativeConfig,
    }
    server.src.services.router --> "server/src/__tests__/services/declarative-config-profiles.test" {
        resolveRoutingChain,
    }
    server.src.db.index --> "server/src/__tests__/services/declarative-config.test" {
        getDb,
        getSetting,
        initDb,
        setSetting,
    }
    "server/src/services/declarative-config" --> "server/src/__tests__/services/declarative-config.test" {
        activateConfiguredLicense,
        applyDeclarativeConfig,
        applyDeclarativeConfigFromEnv,
    }
    server.src.services.router --> "server/src/__tests__/services/declarative-config.test" {
        getRoutingStrategy,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/declarative-config.test" {
        SETTING_LICENSE_KEY,
    }
    server.src.db.index --> "server/src/__tests__/services/degradation.test";
    server.src.lib.crypto --> "server/src/__tests__/services/degradation.test";
    server.src.services.degradation --> "server/src/__tests__/services/degradation.test";
    server.src.db.index --> "server/src/__tests__/services/electronhub-embeddings.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/electronhub-embeddings.test" {
        encrypt,
    }
    server.src.services.embeddings --> "server/src/__tests__/services/electronhub-embeddings.test" {
        EMBEDDING_PLATFORMS,
        runEmbeddings,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/electronhub-embeddings.test" {
        applyCatalog,
    }
    server.src.db.index --> "server/src/__tests__/services/electronhub-images.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/electronhub-images.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/electronhub-images.test" {
        runImageGeneration,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/electronhub-images.test" {
        clearAllCooldowns,
    }
    server.src.db.index --> "server/src/__tests__/services/electronhub-speech.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/electronhub-speech.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/electronhub-speech.test" {
        MEDIA_PLATFORMS,
        runSpeech,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/electronhub-speech.test" {
        applyCatalog,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/services/electronhub-speech.test" {
        isBuiltinDiscoveryEligible,
    }
    server.src.db.index --> "server/src/__tests__/services/embedding-rate-limit-config.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/embedding-rate-limit-config.test" {
        encrypt,
    }
    server.src.services.embeddings --> "server/src/__tests__/services/embedding-rate-limit-config.test" {
        registerCustomEmbeddingModel,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/embedding-rate-limit-config.test" {
        catalogShapeProblems,
    }
    server.src.app --> "server/src/__tests__/services/embedding-source-provenance.test" {
        createApp,
    }
    server.src.db.index --> "server/src/__tests__/services/embedding-source-provenance.test" {
        getDb,
        initDb,
    }
    "server/src/db/migrations/20261118_000001_embedding_source_provenance" --> "server/src/__tests__/services/embedding-source-provenance.test" {
        down,
        up,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/embedding-source-provenance.test" {
        applyCatalog,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/services/embedding-source-provenance.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.db.index --> "server/src/__tests__/services/embeddings-input-type.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/embeddings-input-type.test" { encrypt }
    server.src.services.embeddings --> "server/src/__tests__/services/embeddings-input-type.test" {
        asEmbeddingInputType,
        probeEmbeddingDimensions,
        registerCustomEmbeddingModel,
        runEmbeddings,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/services/embeddings-input-type.test" {
        stubPublicDns,
    }
    server.src.db.index --> "server/src/__tests__/services/embeddings-rate-limits.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/embeddings-rate-limits.test" {
        encrypt,
    }
    server.src.services.embeddings --> "server/src/__tests__/services/embeddings-rate-limits.test" {
        embeddingRateLimitModelId,
        runEmbeddings,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/embeddings-rate-limits.test" {
        invalidateWindowUsage,
        recordRequest,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/services/embeddings-rate-limits.test" {
        stubPublicDns,
    }
    server.src.db.index --> "server/src/__tests__/services/embeddings.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/embeddings.test" { encrypt }
    server.src.services.embeddings --> "server/src/__tests__/services/embeddings.test" {
        getDefaultFamily,
        resolveFamily,
        runEmbeddings,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/embeddings.test" {
        clearCooldownsForKey,
        setCooldown,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/services/embeddings.test" {
        stubPublicDns,
    }
    server.src.services.router --> "server/src/__tests__/services/exhaustion-summary.test" {
        formatResetEta,
        summarizeExhaustion,
    }
    server.src.db.index --> "server/src/__tests__/services/freeinference-embeddings.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/freeinference-embeddings.test" {
        encrypt,
    }
    server.src.services.embeddings --> "server/src/__tests__/services/freeinference-embeddings.test" {
        EMBEDDING_PLATFORMS,
        runEmbeddings,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/freeinference-embeddings.test" {
        applyCatalog,
    }
    server.src.db.index --> "server/src/__tests__/services/freetts-media.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/freetts-media.test" { encrypt }
    server.src.providers.freetts --> "server/src/__tests__/services/freetts-media.test" {
        FreeTtsProvider,
    }
    server.src.providers.index --> "server/src/__tests__/services/freetts-media.test" {
        getProvider,
    }
    "server/src/services/media-freetts" --> "server/src/__tests__/services/freetts-media.test" {
        freeTtsSpeech,
    }
    server.src.services.media --> "server/src/__tests__/services/freetts-media.test" { runSpeech }
    "server/src/services/provider-quota" --> "server/src/__tests__/services/freetts-media.test" {
        inferPoolForPlatform,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/freetts-media.test" {
        applyCatalog,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/services/freetts-media.test" {
        isBuiltinDiscoveryEligible,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/freetts-media.test" {
        clearAllCooldowns,
        isOnCooldown,
    }
    server.src.db.index --> "server/src/__tests__/services/fusion-chain-decision.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/fusion-chain-decision.test" { encrypt }
    server.src.services.ratelimit --> "server/src/__tests__/services/fusion-chain-decision.test" {
        clearAllCooldowns,
    }
    "server/src/lib/client-context" --> "server/src/__tests__/services/fusion-chain-decision.test" {
        clientContextMiddleware,
        setRequestRoutingStrategy,
    }
    server.src.services.router --> "server/src/__tests__/services/fusion-chain-decision.test" {
        getOrderedFusionChain,
        refreshStatsCache,
        setRoutingStrategy,
    }
    "server/src/__tests__/helpers/decision-models" --> "server/src/__tests__/services/fusion-chain-decision.test" {
        seedDecisionModels,
    }
    server.src.db.index --> "server/src/__tests__/services/fusion-provider-moment.test" {
        getDb,
        initDb,
    }
    server.src.services.fusion --> "server/src/__tests__/services/fusion-provider-moment.test" {
        runModelCall,
    }
    server.src.providers.base --> "server/src/__tests__/services/fusion-provider-moment.test" {
        providerRequestError,
    }
    server.src.services.router --> "server/src/__tests__/services/fusion-provider-moment.test" {
        RouteResult,
        getAllPenalties,
    }
    server.src.db.index --> "server/src/__tests__/services/fusion.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/fusion.test" { encrypt }
    server.src.services.router --> "server/src/__tests__/services/fusion.test" {
        resolveFusionCandidate,
        setRoutingStrategy,
    }
    server.src.services.fusion --> "server/src/__tests__/services/fusion.test";
    server.src.lib.proxy --> "server/src/__tests__/services/google-live-file.test";
    "server/src/services/media-google-live" --> "server/src/__tests__/services/google-live-file.test" {
        googleLiveTranscription,
    }
    server.src.db.index --> "server/src/__tests__/services/groq-speech.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/groq-speech.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/groq-speech.test" {
        MEDIA_PLATFORMS,
        runSpeech,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/groq-speech.test" {
        applyCatalog,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/health-error.test" { encrypt }
    server.src.db.index --> "server/src/__tests__/services/health-error.test" { getDb, initDb }
    server.src.services.health --> "server/src/__tests__/services/health-error.test";
    server.src.services.health --> "server/src/__tests__/services/health-interval-env.test";
    server.src.lib.crypto --> "server/src/__tests__/services/health-key-proxy.test" { encrypt }
    "server/src/lib/key-proxy" --> "server/src/__tests__/services/health-key-proxy.test" {
        encryptProxyUrl,
    }
    server.src.db.index --> "server/src/__tests__/services/health-key-proxy.test" { getDb, initDb }
    server.src.services.health --> "server/src/__tests__/services/health-key-proxy.test";
    server.src.lib.proxy --> "server/src/__tests__/services/health-key-proxy.test";
    server.src.db.index --> "server/src/__tests__/services/health-last-healthy.test";
    server.src.lib.crypto --> "server/src/__tests__/services/health-last-healthy.test";
    server.src.services.health --> "server/src/__tests__/services/health-last-healthy.test";
    server.src.db.index --> "server/src/__tests__/services/health-log.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/health-log.test" { encrypt }
    server.src.services.health --> "server/src/__tests__/services/health-log.test";
    server.src.db.index --> "server/src/__tests__/services/health-no-poll-provider.test";
    server.src.lib.crypto --> "server/src/__tests__/services/health-no-poll-provider.test";
    server.src.services.health --> "server/src/__tests__/services/health-no-poll-provider.test";
    server.src.providers.serpsearch --> "server/src/__tests__/services/health-no-poll-provider.test";
    server.src.providers.exa --> "server/src/__tests__/services/health-no-poll-provider.test";
    server.src.providers.parallel --> "server/src/__tests__/services/health-no-poll-provider.test";
    server.src.lib.scheduler --> "server/src/__tests__/services/health-probe-pacing.test" {
        Scheduler,
    }
    server.src.db.index --> "server/src/__tests__/services/health-probe-pacing.test";
    server.src.lib.crypto --> "server/src/__tests__/services/health-probe-pacing.test";
    server.src.services.health --> "server/src/__tests__/services/health-probe-pacing.test";
    server.src.lib.crypto --> "server/src/__tests__/services/health-quota-poll.test" { encrypt }
    server.src.db.index --> "server/src/__tests__/services/health-quota-poll.test" { getDb, initDb }
    server.src.services.health --> "server/src/__tests__/services/health-quota-poll.test";
    server.src.db.index --> "server/src/__tests__/services/health-scheduler.test" { initDb }
    server.src.services.health --> "server/src/__tests__/services/health-scheduler.test" {
        HEALTH_CHECK_INTERVAL_MS,
        startHealthChecker,
        stopHealthChecker,
    }
    server.src.lib.scheduler --> "server/src/__tests__/services/health-scheduler.test" { Scheduler }
    server.src.db.index --> "server/src/__tests__/services/health-transport-park.test";
    server.src.lib.crypto --> "server/src/__tests__/services/health-transport-park.test";
    server.src.services.health --> "server/src/__tests__/services/health-transport-park.test";
    server.src.db.index --> "server/src/__tests__/services/health-transport-preserve.test";
    server.src.lib.crypto --> "server/src/__tests__/services/health-transport-preserve.test";
    server.src.services.health --> "server/src/__tests__/services/health-transport-preserve.test";
    server.src.db.index --> "server/src/__tests__/services/health-unverifiable-provider.test";
    server.src.lib.crypto --> "server/src/__tests__/services/health-unverifiable-provider.test";
    server.src.services.health --> "server/src/__tests__/services/health-unverifiable-provider.test";
    server.src.db.index --> "server/src/__tests__/services/health-validation-ratelimit.test";
    server.src.lib.crypto --> "server/src/__tests__/services/health-validation-ratelimit.test";
    server.src.services.health --> "server/src/__tests__/services/health-validation-ratelimit.test";
    server.src.db.index --> "server/src/__tests__/services/health-verification-basis.test";
    server.src.lib.crypto --> "server/src/__tests__/services/health-verification-basis.test";
    server.src.services.health --> "server/src/__tests__/services/health-verification-basis.test";
    server.src.db.index --> "server/src/__tests__/services/health-zhipu-global.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/health-zhipu-global.test" { encrypt }
    server.src.services.health --> "server/src/__tests__/services/health-zhipu-global.test" {
        checkKeyHealth,
    }
    server.src.db.index --> "server/src/__tests__/services/idempotency.test" { initDb }
    server.src.services.idempotency --> "server/src/__tests__/services/idempotency.test" {
        clearIdempotencyResult,
        computeIdempotencyFingerprint,
        hashIdempotencyKey,
        idempotencyTtlMs,
        lookupIdempotencyReplay,
        normalizeIdempotencyKey,
        storeIdempotencyResult,
    }
    server.src.db.index --> "server/src/__tests__/services/inferbase-embeddings.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/inferbase-embeddings.test" { encrypt }
    server.src.services.embeddings --> "server/src/__tests__/services/inferbase-embeddings.test" {
        EMBEDDING_PLATFORMS,
        runEmbeddings,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/inferbase-embeddings.test" {
        applyCatalog,
    }
    server.src.db.index --> "server/src/__tests__/services/iteracompute.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/services/iteracompute.test" { getProvider }
    server.src.providers.iteracompute --> "server/src/__tests__/services/iteracompute.test" {
        ITERACOMPUTE_BASE_URL,
        IteraComputeProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/services/iteracompute.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/services/iteracompute.test" {
        inferPoolForPlatform,
    }
    server.src.db.index --> "server/src/__tests__/services/kenari-mistral-media.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/kenari-mistral-media.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/kenari-mistral-media.test" {
        MEDIA_PLATFORMS,
        TRANSCRIPTION_PLATFORMS,
        runImageGeneration,
        runTranscription,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/kenari-mistral-media.test" {
        applyCatalog,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/kenari-mistral-media.test" {
        clearAllCooldowns,
    }
    server.src.db.index --> "server/src/__tests__/services/key-budget.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/key-budget.test" { encrypt }
    "server/src/services/request-retention" --> "server/src/__tests__/services/key-budget.test" {
        pruneRequestAnalytics,
    }
    server.src.services.router --> "server/src/__tests__/services/key-budget.test" {
        routePinnedModel,
        routeRequest,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/services/key-budget.test" {
        routingExhaustionBody,
        setExhaustionHeaders,
    }
    "server/src/db/migrations/20260914_000001_key_monthly_usage" --> "server/src/__tests__/services/key-budget.test";
    "server/src/services/key-budget" --> "server/src/__tests__/services/key-budget.test" {
        checkMonthlyBudget,
        getMonthlyBudgetCaps,
        getMonthlyUsage,
        nextMonthResetAt,
        reserveMonthlyBudget,
        secondsUntilNextMonth,
        setMonthlyBudgetCaps,
    }
    server.src.db.index --> "server/src/__tests__/services/key-concurrency.test" { initDb }
    server.src.services.ratelimit --> "server/src/__tests__/services/key-concurrency.test" {
        acquireLease,
        canUseKeyConcurrency,
        getKeyConcurrencyLimit,
        inFlightForKey,
        releaseLease,
        resetLeases,
    }
    server.src.db.index --> "server/src/__tests__/services/keyless-defaults.test" {
        getDb,
        getSetting,
        initDb,
        setSetting,
    }
    "server/src/services/keyless-defaults" --> "server/src/__tests__/services/keyless-defaults.test" {
        applyKeylessDefaults,
        availableKeylessProviders,
        dismissAvailableKeylessProviders,
        enableAvailableKeylessProviders,
        keylessPlatformsInCatalog,
    }
    server.src.db.index --> "server/src/__tests__/services/learn-context-window.test" {
        getDb,
        initDb,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/learn-context-window.test" {
        learnContextWindowFromError,
        parseProviderContextWindow,
    }
    server.src.db.index --> "server/src/__tests__/services/learn-limits.test" { getDb, initDb }
    server.src.services.ratelimit --> "server/src/__tests__/services/learn-limits.test" {
        learnLimitFromError,
        parseProviderLimit,
    }
    server.src.db.index --> "server/src/__tests__/services/license-activation-offline.test" {
        getSetting,
        initDb,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/license-activation-offline.test" {
        SETTING_LICENSE_KEY,
        catalogFetch,
        getCachedLicenseStatus,
        startCatalogSync,
        stopCatalogSync,
        storeActivatedLicense,
    }
    server.src.lib.scheduler --> "server/src/__tests__/services/license-activation-offline.test" {
        Scheduler,
    }
    server.src.db.index --> "server/src/__tests__/services/llmtr-embeddings.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/llmtr-embeddings.test" { encrypt }
    server.src.services.embeddings --> "server/src/__tests__/services/llmtr-embeddings.test" {
        EMBEDDING_PLATFORMS,
        runEmbeddings,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/llmtr-embeddings.test" {
        applyCatalog,
    }
    server.src.db.index --> "server/src/__tests__/services/match-tier-routing.test" {
        getDb,
        initDb,
    }
    server.src.services.router --> "server/src/__tests__/services/match-tier-routing.test" {
        refreshStatsCache,
        resolveModelGroupCandidates,
        routeRequest,
        setRoutingStrategy,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/match-tier-routing.test" { encrypt }
    server.src.db.index --> "server/src/__tests__/services/media-nov01.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/media-nov01.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/media-nov01.test" {
        runSpeech,
        runTranscription,
        runVideoGeneration,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/media-nov01.test" {
        applyCatalog,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/media-nov01.test" {
        clearAllCooldowns,
    }
    server.src.providers.novai --> "server/src/__tests__/services/media-nov01.test" {
        NovaiProvider,
    }
    "server/src/lib/url-guard" --> "server/src/__tests__/services/media-nov01.test";
    server.src.db.index --> "server/src/__tests__/services/media.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/media.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/media.test" {
        runImageGeneration,
        runSpeech,
        runTranscription,
        runVideoGeneration,
    }
    "server/src/services/custom-media-register" --> "server/src/__tests__/services/media.test" {
        registerCustomMediaModel,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/media.test" {
        clearCooldownsForKey,
        isOnCooldown,
        setCooldown,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/services/media.test" {
        stubPublicDns,
    }
    server.src.lib.proxy --> "server/src/__tests__/services/meldport-solaria.test";
    server.src.providers.index --> "server/src/__tests__/services/meldport-solaria.test" {
        getProvider,
    }
    "server/src/services/media-solaria" --> "server/src/__tests__/services/meldport-solaria.test" {
        solariaTranscription,
    }
    "server/src/services/model-discovery" --> "server/src/__tests__/services/model-discovery.test" {
        MAX_CATALOG_BYTES,
        MAX_DISCOVERED_MODELS,
        ModelDiscoveryError,
        parseModelCatalog,
        readCappedBody,
    }
    "server/src/services/model-groups" --> "server/src/__tests__/services/model-groups.test" {
        GroupableRow,
        UnifyOverrides,
        demotedMemberIds,
        groupRows,
        normalizeGroupKey,
        resolveRequestedIdToMembers,
        resolveRequestedIdToTieredMembers,
        slugifyGroupLabel,
        stripProviderSuffix,
    }
    server.src.db.index --> "server/src/__tests__/services/model-listing-execution-status.test" {
        getDb,
        initDb,
    }
    "server/src/services/model-listing" --> "server/src/__tests__/services/model-listing-execution-status.test" {
        buildModelListing,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/model-listing-execution-status.test" {
        setCooldown,
    }
    server.src.db.index --> "server/src/__tests__/services/model-probe.test" { getDb, initDb }
    "server/src/services/model-probe" --> "server/src/__tests__/services/model-probe.test" {
        MODEL_PROBE_STALE_MS,
        ProbeCandidate,
        probeModel,
        recordProbeResult,
        resetModelProbeState,
        runModelProbePass,
        selectProbeCandidates,
        startModelProbe,
        stopModelProbe,
    }
    server.src.db.index --> "server/src/__tests__/services/model-retirement.test" { getDb, initDb }
    "server/src/lib/error-classify" --> "server/src/__tests__/services/model-retirement.test" {
        modelRetirementSignal,
    }
    "server/src/services/model-state" --> "server/src/__tests__/services/model-retirement.test" {
        getCatalogModelTombstone,
        recordCatalogModelTombstone,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/model-retirement.test" {
        applyCatalog,
    }
    server.src.db.index --> "server/src/__tests__/services/model-state-overrides.test" {
        getDb,
        initDb,
        setSetting,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/model-state-overrides.test" {
        applyCatalog,
    }
    "server/src/services/model-state" --> "server/src/__tests__/services/model-state-overrides.test" {
        applyModelOverrides,
        getModelOverrides,
        upsertModelOverrides,
    }
    "server/src/services/model-weight-overrides" --> "server/src/__tests__/services/model-weight-overrides.test" {
        applyModelWeightOverride,
        getModelWeightOverrides,
        parseModelWeightOverrides,
        resetModelWeightOverrides,
        warnOnRoutingOverrideDrift,
    }
    server.src.db.index --> "server/src/__tests__/services/model-weight-overrides.test" {
        getDb,
        initDb,
        setSetting,
    }
    server.src.db.index --> "server/src/__tests__/services/nov13-catalog-adapters.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/nov13-catalog-adapters.test" {
        encrypt,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/nov13-catalog-adapters.test" {
        applyCatalog,
    }
    server.src.services.embeddings --> "server/src/__tests__/services/nov13-catalog-adapters.test" {
        runEmbeddings,
    }
    server.src.services.decision --> "server/src/__tests__/services/nov13-catalog-adapters.test" {
        CATALOG_DECISION_PLATFORMS,
        runDecision,
    }
    server.src.services.media --> "server/src/__tests__/services/nov13-catalog-adapters.test" {
        TRANSCRIPTION_PLATFORMS,
        runTranscription,
    }
    "server/src/services/cloudflare-neurons" --> "server/src/__tests__/services/nov13-catalog-adapters.test" {
        neuronsFor,
        resetCloudflareNeuronMeter,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/nov13-catalog-adapters.test" {
        clearAllCooldowns,
    }
    server.src.db.index --> "server/src/__tests__/services/novai-chat.test" { getDb, initDb }
    server.src.providers.novai --> "server/src/__tests__/services/novai-chat.test" { NovaiProvider }
    server.src.db.index --> "server/src/__tests__/services/novai-image.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/novai-image.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/novai-image.test" {
        listMediaModels,
        runImageGeneration,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/novai-image.test" {
        applyCatalog,
    }
    "server/src/lib/url-guard" --> "server/src/__tests__/services/novai-image.test";
    "server/src/lib/image-normalize" --> "server/src/__tests__/services/novai-image.test";
    server.src.db.index --> "server/src/__tests__/services/oct27-adapters.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/oct27-adapters.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/oct27-adapters.test" {
        runImageGeneration,
    }
    server.src.services.decision --> "server/src/__tests__/services/oct27-adapters.test" {
        runDecision,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/oct27-adapters.test" {
        clearAllCooldowns,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/oct27-adapters.test" {
        applyCatalog,
    }
    server.src.db.index --> "server/src/__tests__/services/onomeo.test" { getDb, initDb }
    server.src.providers.index --> "server/src/__tests__/services/onomeo.test" { getProvider }
    server.src.providers.onomeo --> "server/src/__tests__/services/onomeo.test" {
        ONOMEO_BASE_URL,
        OnomeoProvider,
    }
    "server/src/lib/key-parser" --> "server/src/__tests__/services/onomeo.test" {
        AUTH_JSON_PROVIDER_MAP,
        parseKeysFromFile,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/services/onomeo.test" {
        inferPoolForPlatform,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/onomeo.test" {
        applyCatalog,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/services/onomeo.test" {
        isBuiltinDiscoveryEligible,
    }
    server.src.app --> "server/src/__tests__/services/profile-routing-strategy.test" { createApp }
    server.src.db.index --> "server/src/__tests__/services/profile-routing-strategy.test" {
        getDb,
        initDb,
    }
    server.src.__tests__.helpers.auth --> "server/src/__tests__/services/profile-routing-strategy.test" {
        isGatedApiPath,
        mintDashboardToken,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/profile-routing-strategy.test" {
        encrypt,
    }
    server.src.services.router --> "server/src/__tests__/services/profile-routing-strategy.test" {
        resolveRoutingChain,
        routeRequest,
    }
    server.src.db.index --> "server/src/__tests__/services/provider-minute-cap.test" {
        getDb,
        initDb,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/provider-minute-cap.test" {
        canUseProviderMinute,
        getProviderMinuteRequestCap,
        providerMinuteRequestCount,
    }
    server.src.db.index --> "server/src/__tests__/services/provider-quota.test" { getDb, initDb }
    "server/src/services/provider-quota" --> "server/src/__tests__/services/provider-quota.test" {
        getQuotaStateForKeys,
        inferQuotaPoolKey,
        parseQuotaObservationsFromResponse,
        recordQuotaObservation,
    }
    "server/src/services/request-retention" --> "server/src/__tests__/services/provider-quota.test" {
        pruneQuotaObservations,
    }
    server.src.db.index --> "server/src/__tests__/services/provider-reported-routing.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/provider-reported-routing.test" {
        encrypt,
    }
    server.src.services.router --> "server/src/__tests__/services/provider-reported-routing.test" {
        routeRequest,
        setRoutingStrategy,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/services/provider-reported-routing.test" {
        fallbackRoutingTokens,
        newFallbackState,
        recordRetryableFailure,
    }
    server.src.db.index --> "server/src/__tests__/services/provisional-usage.test" { getDb, initDb }
    server.src.services.ratelimit --> "server/src/__tests__/services/provisional-usage.test" {
        acquireLease,
        canMakeRequest,
        canUseProvider,
        canUseProviderMinute,
        canUseTokens,
        recordRequest,
        releaseLease,
        resetLeases,
    }
    server.src.db.index --> "server/src/__tests__/services/quirks.test" { getDb, initDb }
    server.src.services.quirks --> "server/src/__tests__/services/quirks.test" {
        listQuirkDefinitions,
        quirkKey,
        resolveQuirksByModel,
    }
    server.src.db.types --> server.src.services.quirks { Db }
    server.src.db.index --> server.src.services.quirks { getDb }
    server.src.db.index --> "server/src/__tests__/services/quota-forecast.test" { getDb, initDb }
    "server/src/services/quota-forecast" --> "server/src/__tests__/services/quota-forecast.test" {
        getQuotaForecast,
    }
    server.src.db.index --> "server/src/__tests__/services/quota-outlook.test" { getDb, initDb }
    "server/src/services/quota-outlook" --> "server/src/__tests__/services/quota-outlook.test" {
        getQuotaOutlook,
    }
    "server/src/services/quota-forecast" --> "server/src/__tests__/services/quota-outlook.test" {
        getQuotaForecast,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/services/quota-outlook.test" {
        getQuotaStateForKeys,
        recordQuotaObservation,
        recordQuotaObservationsFromResponse,
    }
    server.src.db.index --> "server/src/__tests__/services/ratelimit-cooldown-ceiling.test" {
        getSetting,
        initDb,
        setSetting,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/services/ratelimit-cooldown-ceiling.test" {
        cooldownDecisionForError,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/ratelimit-cooldown-ceiling.test" {
        COOLDOWN_CEILING_KEY,
        MODEL_FORBIDDEN_COOLDOWN_MS,
        PAYMENT_REQUIRED_COOLDOWN_MS,
        capCooldownMs,
        getCooldownCeilingMs,
        getModelForbiddenCooldownMs,
        getNextCooldownDuration,
        getPaymentRequiredCooldownMs,
        setCooldownCeilingMs,
    }
    server.src.services.router --> "server/src/__tests__/services/ratelimit-cooldown-ceiling.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/services/ratelimit-cooldown-error-kind.test" {
        initDb,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/services/ratelimit-cooldown-error-kind.test" {
        cooldownDecisionForError,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/ratelimit-cooldown-error-kind.test" {
        getNextCooldownDuration,
        recentHitCount,
        recordRequest,
    }
    server.src.services.router --> "server/src/__tests__/services/ratelimit-cooldown-error-kind.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/services/ratelimit-cooldown-no-shorten.test" {
        getDb,
        initDb,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/ratelimit-cooldown-no-shorten.test" {
        CooldownSource,
        clearAllCooldowns,
        clearCooldownEarly,
        clearCooldownsForKey,
        getCooldownSource,
        isOnCooldown,
        setCooldown,
    }
    server.src.db.index --> "server/src/__tests__/services/ratelimit-daily-boundary.test" {
        getDb,
        initDb,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/ratelimit-daily-boundary.test" {
        canMakeRequest,
        canUseProvider,
        clearCooldownsForKey,
        getActiveCooldownsForKeys,
        isOnCooldown,
        pacificMidnight,
        providerDailyRequestCount,
        providerDailyTokenCount,
        setCooldown,
    }
    server.src.db.index --> "server/src/__tests__/services/ratelimit-local-endpoint.test" {
        getDb,
        initDb,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/services/ratelimit-local-endpoint.test" {
        cooldownDecisionForError,
    }
    server.src.services.router --> "server/src/__tests__/services/ratelimit-local-endpoint.test" {
        RouteResult,
    }
    server.src.db.index --> "server/src/__tests__/services/ratelimit-retention.test" {
        getDb,
        initDb,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/ratelimit-retention.test" {
        canMakeRequest,
        canUseTokens,
        cleanupExpiredCooldowns,
        isOnCooldown,
        recordRequest,
        recordTokens,
        setCooldown,
    }
    server.src.db.index --> "server/src/__tests__/services/ratelimit.test";
    server.src.db.index --> "server/src/__tests__/services/ratelimit.test" { getDb, initDb }
    server.src.services.ratelimit --> "server/src/__tests__/services/ratelimit.test";
    server.src.services.ratelimit --> "server/src/__tests__/services/ratelimit.test" {
        canMakeRequest,
        canUseProvider,
        canUseProviderTokens,
        canUseTokens,
        getCooldownDurationForLimit,
        getNextCooldownDuration,
        getProviderDailyRequestCap,
        getProviderDailyTokenCap,
        getRateLimitStatus,
        providerDailyRequestCount,
        providerDailyTokenCount,
        recentHitCount,
        recordRequest,
        recordTokens,
    }
    server.src.providers.base --> "server/src/__tests__/services/ratelimit.test" {
        parseRetryAfterMs,
    }
    server.src.db.index --> "server/src/__tests__/services/request-retention.test" { getDb, initDb }
    "server/src/services/request-retention" --> "server/src/__tests__/services/request-retention.test" {
        getRequestAnalyticsRetentionConfig,
        pruneRequestAnalytics,
    }
    server.src.db.index --> "server/src/__tests__/services/rerank-monthly-budget.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/rerank-monthly-budget.test" { encrypt }
    server.src.services.rerank --> "server/src/__tests__/services/rerank-monthly-budget.test" {
        RerankError,
        runRerank,
    }
    "server/src/services/key-budget" --> "server/src/__tests__/services/rerank-monthly-budget.test" {
        getMonthlyUsage,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/services/rerank-monthly-budget.test" {
        stubPublicDns,
    }
    server.src.services.rerank --> "server/src/__tests__/services/rerank.test" {
        RerankError,
        runRerank,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/services/rerank.test" {
        stubPublicDns,
    }
    server.src.db.index --> "server/src/__tests__/services/rime-media.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/rime-media.test" { encrypt }
    server.src.lib.proxy --> "server/src/__tests__/services/rime-media.test";
    server.src.providers.rime --> "server/src/__tests__/services/rime-media.test" { RimeProvider }
    server.src.providers.index --> "server/src/__tests__/services/rime-media.test" { getProvider }
    server.src.services.media --> "server/src/__tests__/services/rime-media.test" {
        runSpeech,
        runTranscription,
    }
    "server/src/services/media-rime" --> "server/src/__tests__/services/rime-media.test" { rimePcm }
    "server/src/services/provider-quota" --> "server/src/__tests__/services/rime-media.test" {
        inferPoolForPlatform,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/rime-media.test" {
        applyCatalog,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/services/rime-media.test" {
        isBuiltinDiscoveryEligible,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/rime-media.test" {
        clearAllCooldowns,
        isOnCooldown,
    }
    server.src.services.router --> "server/src/__tests__/services/router-bandit.test" {
        applyReliabilityFloor,
        getCommunityPrior,
        getCommunityPriorEnabled,
        getCustomWeights,
        getExploreEnabled,
        getPeakHoursConfig,
        getRoutingScores,
        getRoutingStrategy,
        refreshStatsCache,
        routeRequest,
        setCommunityPriorEnabled,
        setCommunityPriors,
        setCustomWeights,
        setExploreEnabled,
        setMinReliabilityFloor,
        setPeakHoursConfig,
        setRoutingStrategy,
    }
    server.src.services.scoring --> "server/src/__tests__/services/router-bandit.test" {
        BANDIT_PRESETS,
        DEFAULT_PEAK_HOURS,
    }
    "server/src/services/model-weight-overrides" --> "server/src/__tests__/services/router-bandit.test" {
        resetModelWeightOverrides,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/router-bandit.test";
    server.src.db.index --> "server/src/__tests__/services/router-bandit.test" { getDb, initDb }
    server.src.__tests__.helpers.chain --> "server/src/__tests__/services/router-bandit.test" {
        addToActiveChain,
    }
    "server/src/lib/tool-capability" --> "server/src/__tests__/services/router-bandit.test" {
        benchForTools,
        resetToolCapability,
        toolCapabilityKey,
    }
    server.src.services.router --> "server/src/__tests__/services/router-key-bandit.test" {
        refreshStatsCache,
        routeRequest,
        setRoutingStrategy,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/router-key-bandit.test";
    server.src.db.index --> "server/src/__tests__/services/router-key-bandit.test" { getDb, initDb }
    server.src.__tests__.helpers.chain --> "server/src/__tests__/services/router-key-bandit.test" {
        addToActiveChain,
    }
    server.src.db.index --> "server/src/__tests__/services/router-key-proxy.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/router-key-proxy.test" { encrypt }
    "server/src/lib/key-proxy" --> "server/src/__tests__/services/router-key-proxy.test" {
        encryptProxyUrl,
    }
    server.src.services.router --> "server/src/__tests__/services/router-key-proxy.test" {
        routeRequest,
        setRoutingStrategy,
    }
    server.src.db.index --> "server/src/__tests__/services/router-keycount-budget.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/router-keycount-budget.test" {
        encrypt,
    }
    server.src.services.router --> "server/src/__tests__/services/router-keycount-budget.test" {
        getRoutingScores,
        refreshStatsCache,
    }
    server.src.db.index --> "server/src/__tests__/services/router-model-scope.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/router-model-scope.test" { encrypt }
    server.src.services.router --> "server/src/__tests__/services/router-model-scope.test" {
        hasOtherUsableKey,
        routeRequest,
        setRoutingStrategy,
    }
    server.src.services.router --> "server/src/__tests__/services/router-priority-penalty.test" {
        recordRateLimitHit,
        recordSuccess,
        refreshStatsCache,
        routeRequest,
        setRoutingStrategy,
    }
    server.src.db.index --> "server/src/__tests__/services/router-priority-penalty.test" {
        getDb,
        initDb,
    }
    server.src.__tests__.helpers.chain --> "server/src/__tests__/services/router-priority-penalty.test" {
        addToActiveChain,
    }
    server.src.services.router --> "server/src/__tests__/services/router-provider-moment-stats.test" {
        getRoutingScores,
        refreshStatsCache,
        setProviderMomentAttribution,
    }
    server.src.db.index --> "server/src/__tests__/services/router-provider-moment-stats.test" {
        getDb,
        initDb,
    }
    "server/src/lib/request-log" --> "server/src/__tests__/services/router-provider-moment-stats.test" {
        logRequest,
    }
    server.src.db.index --> "server/src/__tests__/services/router-settings-cache.test" {
        getDb,
        initDb,
    }
    server.src.services.router --> "server/src/__tests__/services/router-settings-cache.test" {
        getRoutingStrategy,
        routeRequest,
        setRouterSettingsCacheForTests,
        setRoutingStrategy,
    }
    server.src.services.router --> "server/src/__tests__/services/router-speed-scoring.test" {
        getRoutingScores,
        refreshStatsCache,
        resetSpeedRankWriteback,
        setRoutingStrategy,
        writeObservedSpeedRanks,
    }
    server.src.services.scoring --> "server/src/__tests__/services/router-speed-scoring.test" {
        TIMEOUT_LATENCY_CAP_MS,
        observedSpeedRank,
    }
    "server/src/services/model-state" --> "server/src/__tests__/services/router-speed-scoring.test" {
        upsertModelOverrides,
    }
    server.src.db.index --> "server/src/__tests__/services/router-speed-scoring.test" {
        getDb,
        initDb,
    }
    server.src.__tests__.helpers.chain --> "server/src/__tests__/services/router-speed-scoring.test" {
        addToActiveChain,
    }
    server.src.services.router --> "server/src/__tests__/services/router-task-type.test" {
        refreshStatsCache,
        routeRequest,
        setRoutingStrategy,
    }
    server.src.db.index --> "server/src/__tests__/services/router-task-type.test" { getDb, initDb }
    server.src.__tests__.helpers.chain --> "server/src/__tests__/services/router-task-type.test" {
        addToActiveChain,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/router-task-type.test";
    server.src.db.index --> "server/src/__tests__/services/router-usable-key-monthly.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/router-usable-key-monthly.test" {
        encrypt,
    }
    server.src.services.router --> "server/src/__tests__/services/router-usable-key-monthly.test" {
        hasOtherUsableKey,
        hasUsableKeyForModel,
        setRoutingStrategy,
    }
    server.src.db.index --> "server/src/__tests__/services/router-window-headroom.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/router-window-headroom.test" {
        encrypt,
    }
    server.src.services.router --> "server/src/__tests__/services/router-window-headroom.test" {
        getRoutingScores,
        refreshStatsCache,
        setHeadroomThresholds,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/router-window-headroom.test" {
        invalidateWindowUsage,
        modelWindowUsedFraction,
    }
    server.src.db.index --> "server/src/__tests__/services/router.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/router.test" { encrypt }
    server.src.services.router --> "server/src/__tests__/services/router.test" {
        getAllPenalties,
        recordRateLimitHit,
        routeRequest,
        setRoutingStrategy,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/router.test" { setCooldown }
    server.src.db.index --> "server/src/__tests__/services/routing-decision.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/routing-decision.test" { encrypt }
    server.src.services.ratelimit --> "server/src/__tests__/services/routing-decision.test" {
        clearAllCooldowns,
    }
    "server/src/lib/client-context" --> "server/src/__tests__/services/routing-decision.test" {
        clientContextMiddleware,
        getClientContext,
    }
    server.src.services.router --> "server/src/__tests__/services/routing-decision.test" {
        effectiveRoutingStrategy,
        setRoutingStrategy,
    }
    "server/src/services/routing-decision" --> "server/src/__tests__/services/routing-decision.test";
    "server/src/services/routing-decision" --> "server/src/__tests__/services/routing-decision.test" {
        DECISION_TIMEOUT_MS,
        ROUTER_CLIENT,
        applyDecisionRouting,
        chooseRoutingPreset,
        decisionStateFor,
        getDecisionRoutingSettings,
        getDecisionRoutingStats,
        resetDecisionRoutingCache,
        routingStrategyHeader,
        setDecisionRoutingSettings,
    }
    "server/src/__tests__/helpers/decision-models" --> "server/src/__tests__/services/routing-decision.test" {
        seedDecisionModels,
    }
    server.src.services.router --> "server/src/__tests__/services/routing-exhaustion.test" {
        routeRequest,
        setRoutingStrategy,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/routing-exhaustion.test";
    server.src.db.index --> "server/src/__tests__/services/routing-exhaustion.test" {
        getDb,
        initDb,
    }
    server.src.services.router --> "server/src/__tests__/services/routing-keyless-filter.test" {
        routeRequest,
        setRoutingStrategy,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/routing-keyless-filter.test";
    server.src.db.index --> "server/src/__tests__/services/routing-keyless-filter.test" {
        getDb,
        initDb,
    }
    "server/src/lib/fallback-loop" --> "server/src/__tests__/services/routing-keyless-filter.test" {
        routingExhaustionBody,
    }
    server.src.services.scoring --> "server/src/__tests__/services/scoring.test" {
        BANDIT_PRESETS,
        DEFAULT_PEAK_HOURS,
        HEADROOM_FLOOR,
        PEAK_SPEED_TO_RELIABILITY,
        PeakHoursConfig,
        SPEED_PRIOR,
        TASK_WEIGHT_SHARE,
        combineScore,
        expectedReliability,
        headroomFactor,
        hourInTimezone,
        intelligenceComposite,
        intelligenceScore,
        isPeakExemptStrategy,
        isPeakHours,
        isTaskExemptStrategy,
        isValidPeakHour,
        isValidTimezone,
        peakAdjustedWeights,
        rateLimitFactor,
        rateWindowHeadroomFactor,
        reliabilityPosterior,
        sampleBeta,
        speedScore,
        taskAdjustedWeights,
    }
    server.src.db.index --> "server/src/__tests__/services/search-spend-ledger.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/search-spend-ledger.test" { encrypt }
    server.src.services.ratelimit --> "server/src/__tests__/services/search-spend-ledger.test" {
        clearAllCooldowns,
    }
    server.src.services.search --> "server/src/__tests__/services/search-spend-ledger.test" {
        SearchError,
        runSearch,
    }
    "server/src/services/key-budget" --> "server/src/__tests__/services/search-spend-ledger.test" {
        getMonthlyUsage,
    }
    "server/src/__tests__/helpers/search-engines" --> "server/src/__tests__/services/search-spend-ledger.test" {
        seedSearchEngines,
    }
    server.src.db.index --> "server/src/__tests__/services/search.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/search.test" { encrypt }
    server.src.services.ratelimit --> "server/src/__tests__/services/search.test" {
        clearAllCooldowns,
        isOnCooldown,
        setCooldown,
    }
    server.src.providers.index --> "server/src/__tests__/services/search.test" { getProvider }
    server.src.providers.brave --> "server/src/__tests__/services/search.test" { BraveProvider }
    server.src.services.search --> "server/src/__tests__/services/search.test" {
        SEARCH_PLATFORM_INFO,
        SearchError,
        decodeEntities,
        listSearchEngines,
        noSearchMessage,
        runSearch,
        searchAnalytics,
        searchAvailable,
        searchStatus,
        updateSearchEngine,
    }
    shared.types --> "server/src/__tests__/services/search.test" { SEARCH_PLATFORMS }
    "server/src/lib/search-platforms" --> "server/src/__tests__/services/search.test" {
        SEARCH_PLATFORMS,
    }
    "server/src/__tests__/helpers/search-engines" --> "server/src/__tests__/services/search.test" {
        seedSearchEngines,
    }
    server.src.services.health --> "server/src/__tests__/services/search.test" {
        clearLastHealthyStampState,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/services/search.test" {
        stubPublicDns,
    }
    "server/src/services/model-listing" --> "server/src/__tests__/services/servable-context-window.test" {
        servableContextWindow,
    }
    server.src.db.index --> "server/src/__tests__/services/served-nonchat-marks-key-healthy.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/served-nonchat-marks-key-healthy.test" {
        encrypt,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/served-nonchat-marks-key-healthy.test" {
        clearAllCooldowns,
    }
    server.src.services.health --> "server/src/__tests__/services/served-nonchat-marks-key-healthy.test" {
        clearLastHealthyStampState,
    }
    server.src.services.embeddings --> "server/src/__tests__/services/served-nonchat-marks-key-healthy.test" {
        runEmbeddings,
    }
    server.src.services.rerank --> "server/src/__tests__/services/served-nonchat-marks-key-healthy.test" {
        runRerank,
    }
    server.src.services.decision --> "server/src/__tests__/services/served-nonchat-marks-key-healthy.test" {
        runDecision,
    }
    server.src.services.media --> "server/src/__tests__/services/served-nonchat-marks-key-healthy.test" {
        runImageGeneration,
    }
    "server/src/__tests__/helpers/decision-models" --> "server/src/__tests__/services/served-nonchat-marks-key-healthy.test" {
        seedDecisionModels,
    }
    server.src.__tests__.helpers.dns --> "server/src/__tests__/services/served-nonchat-marks-key-healthy.test" {
        stubPublicDns,
    }
    server.src.db.index --> "server/src/__tests__/services/silvr-media.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/silvr-media.test" { encrypt }
    server.src.services.embeddings --> "server/src/__tests__/services/silvr-media.test" {
        EMBEDDING_PLATFORMS,
        runEmbeddings,
    }
    server.src.services.media --> "server/src/__tests__/services/silvr-media.test" {
        TRANSCRIPTION_PLATFORMS,
        runTranscription,
    }
    server.src.services.decision --> "server/src/__tests__/services/silvr-media.test" {
        CATALOG_DECISION_PLATFORMS,
        runDecision,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/services/silvr-media.test" {
        inferPoolForPlatform,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/silvr-media.test" {
        clearAllCooldowns,
        isOnCooldown,
    }
    server.src.db.index --> "server/src/__tests__/services/speechflow-freeai.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/speechflow-freeai.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/speechflow-freeai.test" {
        TRANSCRIPTION_PLATFORMS,
        runTranscription,
    }
    server.src.services.embeddings --> "server/src/__tests__/services/speechflow-freeai.test" {
        EMBEDDING_PLATFORMS,
        runEmbeddings,
    }
    server.src.providers.index --> "server/src/__tests__/services/speechflow-freeai.test" {
        resolveProvider,
    }
    server.src.providers.speechflow --> "server/src/__tests__/services/speechflow-freeai.test" {
        speechFlowCredentials,
    }
    server.src.db.index --> "server/src/__tests__/services/transcription.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/transcription.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/transcription.test" {
        MAX_TRANSCRIPTION_BYTES,
        MediaError,
        listMediaModels,
        runTranscription,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/transcription.test" {
        clearCooldownsForKey,
        isOnCooldown,
    }
    server.src.db.index --> "server/src/__tests__/services/typhoon-transcription.test" {
        getDb,
        initDb,
    }
    server.src.lib.crypto --> "server/src/__tests__/services/typhoon-transcription.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/typhoon-transcription.test" {
        TRANSCRIPTION_PLATFORMS,
        runTranscription,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/typhoon-transcription.test" {
        clearCooldownsForKey,
        isOnCooldown,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/typhoon-transcription.test" {
        applyCatalog,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/services/typhoon-transcription.test" {
        isBuiltinDiscoveryEligible,
    }
    server.src.db.index --> "server/src/__tests__/services/varosity-media.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/varosity-media.test" { encrypt }
    server.src.services.media --> "server/src/__tests__/services/varosity-media.test" {
        listMediaModels,
        runImageGeneration,
        runSpeech,
        runVideoGeneration,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/varosity-media.test" {
        applyCatalog,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/varosity-media.test" {
        clearAllCooldowns,
    }
    server.src.providers.varosity --> "server/src/__tests__/services/varosity-media.test" {
        VarosityProvider,
    }
    "server/src/lib/url-guard" --> "server/src/__tests__/services/varosity-media.test";
    "server/src/lib/image-normalize" --> "server/src/__tests__/services/varosity-media.test";
    server.src.db.index --> "server/src/__tests__/services/voice-gateways.test" { getDb, initDb }
    server.src.lib.crypto --> "server/src/__tests__/services/voice-gateways.test" { encrypt }
    "server/src/lib/key-parser" --> "server/src/__tests__/services/voice-gateways.test" {
        parseKeysFromFile,
    }
    server.src.providers.index --> "server/src/__tests__/services/voice-gateways.test" {
        getProvider,
    }
    server.src.services.media --> "server/src/__tests__/services/voice-gateways.test" {
        MEDIA_PLATFORMS,
        TRANSCRIPTION_PLATFORMS,
        runSpeech,
        runTranscription,
    }
    "server/src/services/media-voice-gateways" --> "server/src/__tests__/services/voice-gateways.test" {
        CARTESIA_VERSION,
        cartesiaTranscription,
        voiceGatewaySpeech,
    }
    "server/src/services/provider-quota" --> "server/src/__tests__/services/voice-gateways.test" {
        inferPoolForPlatform,
    }
    "server/src/services/builtin-model-discovery" --> "server/src/__tests__/services/voice-gateways.test" {
        isBuiltinDiscoveryEligible,
    }
    "server/src/services/catalog-sync" --> "server/src/__tests__/services/voice-gateways.test" {
        applyCatalog,
    }
    server.src.services.ratelimit --> "server/src/__tests__/services/voice-gateways.test" {
        clearAllCooldowns,
        isOnCooldown,
    }
    client.src.components.ui.button --> client.src.App { buttonVariants }
    "client/src/components/ui/dropdown-menu" --> client.src.App {
        DropdownMenu,
        DropdownMenuContent,
        DropdownMenuGroup,
        DropdownMenuItem,
        DropdownMenuSeparator,
        DropdownMenuSub,
        DropdownMenuSubContent,
        DropdownMenuSubTrigger,
        DropdownMenuTrigger,
    }
    "client/src/components/auth-gate" --> client.src.App {
        AuthGate,
        AuthStatus,
        ChangeCredentialsModal,
    }
    "client/src/components/command-palette" --> client.src.App { CommandPalette }
    "client/src/components/command-palette-state" --> client.src.App { openCommandPalette }
    "client/src/components/error-boundary" --> client.src.App { ErrorBoundary }
    "client/src/components/settings-dialog" --> client.src.App { SettingsDialog }
    "client/src/components/updates-dialog" --> client.src.App { UpdatesDialog }
    client.src.lib.updates --> client.src.App { OPEN_UPDATES_EVENT }
    client.src.components.toaster --> client.src.App { Toaster }
    "client/src/components/update-reminder" --> client.src.App { UpdateReminder }
    "client/src/components/new-build-prompt" --> client.src.App { NewBuildPrompt }
    "client/src/hooks/use-premium" --> client.src.App { usePremium }
    client.src.i18n.index --> client.src.App { I18nProvider, useI18n }
    client.src.lib.api --> client.src.App { apiFetch, logout }
    client.src.lib.toast --> client.src.App { toast }
    client.src.theme --> client.src.App { ThemeProvider }
    client.src.pages.KeysPage --> client.src.App;
    client.src.pages.PlaygroundPage --> client.src.App;
    client.src.pages.FallbackPage --> client.src.App;
    client.src.pages.ModelDetailPage --> client.src.App;
    client.src.pages.FusionPage --> client.src.App;
    client.src.pages.EmbeddingsPage --> client.src.App;
    client.src.pages.ImagePage --> client.src.App;
    client.src.pages.VideoPage --> client.src.App;
    client.src.pages.AudioPage --> client.src.App;
    client.src.pages.SearchPage --> client.src.App;
    client.src.pages.DecisionPage --> client.src.App;
    client.src.pages.MediaDetailPage --> client.src.App;
    client.src.pages.EmbeddingDetailPage --> client.src.App;
    client.src.pages.AnalyticsPage --> client.src.App;
    client.src.pages.LogsPage --> client.src.App;
    client.src.pages.PremiumPage --> client.src.App;
    client.src.pages.NotFoundPage --> client.src.App;
    client.src.pages.AgentsPage --> client.src.App;
    client.src.lib.api --> "client/src/components/command-palette" { apiFetch }
    client.src.lib.clipboard --> "client/src/components/command-palette" { copyText }
    client.src.lib.toast --> "client/src/components/command-palette" { toast }
    "client/src/components/api-usage" --> "client/src/components/command-palette" { apiBaseUrl }
    "client/src/components/command-palette-state" --> "client/src/components/command-palette" {
        COMMAND_PALETTE_EVENT,
    }
    client.src.i18n.index --> "client/src/components/command-palette" { useI18n }
    client.src.lib.routing --> "client/src/components/command-palette" { FallbackEntry }
    "client/src/theme-context" --> "client/src/components/command-palette" { useTheme }
    client.src.components.ui.button --> "client/src/components/error-boundary" { Button }
    client.src.i18n.index --> "client/src/components/error-boundary" { useI18n }
    client.src.components.ui.dialog --> "client/src/components/updates-dialog" {
        Dialog,
        DialogClose,
        DialogPopup,
        DialogTitle,
    }
    client.src.components.ui.button --> "client/src/components/updates-dialog" {
        Button,
        buttonVariants,
    }
    client.src.components.ui.switch --> "client/src/components/updates-dialog" { Switch }
    "client/src/components/copy-button" --> "client/src/components/updates-dialog" { CopyButton }
    "client/src/components/update-reminder" --> "client/src/components/updates-dialog" {
        UPDATE_CHECK_CHANGED_EVENT,
    }
    client.src.lib.api --> "client/src/components/updates-dialog" { apiFetch }
    "client/src/lib/desktop-updater" --> "client/src/components/updates-dialog" {
        checkDesktopUpdates,
        hasDesktopUpdater,
        useDesktopUpdater,
    }
    "client/src/lib/docker-update" --> "client/src/components/updates-dialog" { useDockerUpdate }
    client.src.lib.updates --> "client/src/components/updates-dialog" { RELEASES_URL }
    client.src.i18n.index --> "client/src/components/updates-dialog" { useI18n }
    client.src.lib.api --> "client/src/components/update-reminder" { apiFetch }
    client.src.lib.updates --> "client/src/components/update-reminder" { openUpdates }
    client.src.i18n.index --> "client/src/components/update-reminder" { useI18n }
    client.src.lib.api --> "client/src/lib/docker-update" { apiFetch }
    "client/src/lib/new-build" --> "client/src/lib/docker-update" {
        fetchLatestIndex,
        isNewBuild,
        loadedEntryScript,
    }
    client.src.lib.toast --> client.src.components.toaster {
        ToastItem,
        dismissToast,
        getToasts,
        subscribeToasts,
    }
    "client/src/lib/toast-timer" --> client.src.components.toaster { startToastTimer }
    client.src.i18n.index --> client.src.components.toaster { useI18n }
    client.src.i18n.index --> "client/src/components/new-build-prompt" { useI18n }
    "client/src/lib/new-build" --> "client/src/components/new-build-prompt" {
        fetchLatestIndex,
        isNewBuild,
        loadedEntryScript,
    }
    client.src.lib.api --> "client/src/hooks/use-premium" { apiFetch }
    client.src.i18n.index --> client.src.pages.ModelDetailPage { useI18n }
    client.src.lib.api --> client.src.pages.ModelDetailPage { apiFetch }
    "client/src/lib/alias-merge" --> client.src.pages.ModelDetailPage {
        addAlias,
        aliasesFor,
        removeAlias,
    }
    client.src.components.ui.button --> client.src.pages.ModelDetailPage { Button }
    "client/src/components/confirm-button" --> client.src.pages.ModelDetailPage { ConfirmButton }
    client.src.components.ui.input --> client.src.pages.ModelDetailPage { Input }
    client.src.components.ui.select --> client.src.pages.ModelDetailPage {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue,
    }
    client.src.components.ui.switch --> client.src.pages.ModelDetailPage { Switch }
    "client/src/components/copy-button" --> client.src.pages.ModelDetailPage { CopyButton }
    client.src.components.ui.skeleton --> client.src.pages.ModelDetailPage { TableSkeleton }
    client.src.components.tooltip --> client.src.pages.ModelDetailPage { Tooltip }
    "client/src/components/page-header" --> client.src.pages.ModelDetailPage { PageHeader }
    "client/src/components/models-tabs" --> client.src.pages.ModelDetailPage { ModelsTabs }
    "client/src/components/model-table" --> client.src.pages.ModelDetailPage {
        ModelTableHead,
        RateLimitBadge,
        RowContent,
    }
    client.src.lib.routing --> client.src.pages.ModelDetailPage {
        FallbackEntry,
        RateLimitUsageData,
        RoutingData,
        Row,
        groupQuotaBadge,
        isMemberDepleted,
        isMemberSplit,
        memberEndpointTitle,
        memberOverrideKey,
        memberProviderLabel,
        providerPinId,
        splitsWithoutMember,
    }
    "client/src/lib/model-settings" --> client.src.pages.ModelDetailPage {
        ModelSettingsPatch,
        ModelSettingsSource,
        RANK_MAX,
        RANK_MIN,
        SIZE_LABELS,
        modelSettingsForm,
        reviewModelSettings,
    }
    client.src.lib.api --> client.src.pages.FusionPage { apiFetch }
    "client/src/lib/model-groups" --> client.src.pages.FusionPage { buildModelOptions }
    "client/src/lib/fusion-filter" --> client.src.pages.FusionPage {
        filterFusionModels,
        fusionProviders,
    }
    client.src.components.ui.button --> client.src.pages.FusionPage { Button }
    client.src.components.ui.input --> client.src.pages.FusionPage { Input }
    client.src.components.ui.switch --> client.src.pages.FusionPage { Switch }
    client.src.components.ui.badge --> client.src.pages.FusionPage { Badge }
    client.src.components.ui.select --> client.src.pages.FusionPage {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue,
    }
    "client/src/components/page-header" --> client.src.pages.FusionPage { PageHeader }
    "client/src/components/floating-bar" --> client.src.pages.FusionPage { FloatingBar }
    "client/src/components/models-tabs" --> client.src.pages.FusionPage { ModelsTabs }
    client.src.i18n.index --> client.src.pages.FusionPage { useI18n }
    client.src.lib.api --> client.src.pages.EmbeddingsPage { apiFetch }
    "client/src/components/model-table" --> client.src.pages.EmbeddingsPage { dragDots }
    client.src.components.ui.button --> client.src.pages.EmbeddingsPage { Button }
    "client/src/components/confirm-button" --> client.src.pages.EmbeddingsPage { ConfirmButton }
    "client/src/components/empty-state" --> client.src.pages.EmbeddingsPage { EmptyState }
    client.src.components.ui.skeleton --> client.src.pages.EmbeddingsPage { CardSkeleton }
    client.src.components.ui.switch --> client.src.pages.EmbeddingsPage { Switch }
    "client/src/components/page-header" --> client.src.pages.EmbeddingsPage { PageHeader }
    "client/src/components/floating-bar" --> client.src.pages.EmbeddingsPage { FloatingBar }
    "client/src/components/models-tabs" --> client.src.pages.EmbeddingsPage { ModelsTabs }
    "client/src/components/usage-summary-card" --> client.src.pages.EmbeddingsPage {
        UsageSummaryCard,
    }
    client.src.i18n.index --> client.src.pages.EmbeddingsPage { useI18n }
    "client/src/components/media-models" --> client.src.pages.ImagePage { MediaModelsView }
    client.src.lib.api --> "client/src/components/media-models" { apiFetch }
    client.src.components.ui.switch --> "client/src/components/media-models" { Switch }
    "client/src/components/confirm-button" --> "client/src/components/media-models" {
        ConfirmButton,
    }
    "client/src/components/empty-state" --> "client/src/components/media-models" { EmptyState }
    client.src.components.ui.skeleton --> "client/src/components/media-models" { CardSkeleton }
    "client/src/components/page-header" --> "client/src/components/media-models" { PageHeader }
    "client/src/components/models-tabs" --> "client/src/components/media-models" { ModelsTabs }
    "client/src/components/usage-summary-card" --> "client/src/components/media-models" {
        UsageSummaryCard,
    }
    client.src.i18n.index --> "client/src/components/media-models" { useI18n }
    "client/src/components/media-models" --> client.src.pages.VideoPage { MediaModelsView }
    "client/src/components/media-models" --> client.src.pages.AudioPage { MediaModelsView }
    "client/src/components/search-engines" --> client.src.pages.SearchPage { SearchEnginesView }
    "client/src/components/decision-models" --> client.src.pages.DecisionPage { DecisionModelsView }
    client.src.i18n.index --> client.src.pages.MediaDetailPage { useI18n }
    client.src.lib.api --> client.src.pages.MediaDetailPage { apiFetch }
    "client/src/components/copy-button" --> client.src.pages.MediaDetailPage { CopyButton }
    "client/src/components/page-header" --> client.src.pages.MediaDetailPage { PageHeader }
    "client/src/components/models-tabs" --> client.src.pages.MediaDetailPage { ModelsTabs }
    client.src.components.ui.switch --> client.src.pages.MediaDetailPage { Switch }
    "client/src/components/api-usage" --> client.src.pages.MediaDetailPage {
        ApiUsageBlock,
        apiBaseUrl,
    }
    "client/src/components/media-models" --> client.src.pages.MediaDetailPage { MediaModel }
    client.src.i18n.index --> client.src.pages.EmbeddingDetailPage { useI18n }
    client.src.lib.api --> client.src.pages.EmbeddingDetailPage { apiFetch }
    "client/src/components/copy-button" --> client.src.pages.EmbeddingDetailPage { CopyButton }
    "client/src/components/page-header" --> client.src.pages.EmbeddingDetailPage { PageHeader }
    "client/src/components/models-tabs" --> client.src.pages.EmbeddingDetailPage { ModelsTabs }
    "client/src/components/api-usage" --> client.src.pages.EmbeddingDetailPage {
        ApiUsageBlock,
        apiBaseUrl,
    }
    client.src.lib.api --> client.src.pages.AnalyticsPage { apiFetch }
    "client/src/components/ui/segmented-control" --> client.src.pages.AnalyticsPage {
        SegmentedControl,
    }
    client.src.components.ui.table --> client.src.pages.AnalyticsPage {
        Table,
        TableBody,
        TableCell,
        TableHead,
        TableHeader,
        TableRow,
    }
    client.src.components.ui.badge --> client.src.pages.AnalyticsPage { Badge }
    client.src.components.ui.dialog --> client.src.pages.AnalyticsPage {
        Dialog,
        DialogClose,
        DialogPopup,
        DialogTitle,
    }
    client.src.components.ui.select --> client.src.pages.AnalyticsPage {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue,
    }
    "client/src/components/page-header" --> client.src.pages.AnalyticsPage { PageHeader }
    client.src.components.ui.skeleton --> client.src.pages.AnalyticsPage { Skeleton }
    client.src.components.tooltip --> client.src.pages.AnalyticsPage { Tooltip }
    "client/src/components/sortable-header" --> client.src.pages.AnalyticsPage { SortableHeader }
    client.src.lib.utils --> client.src.pages.AnalyticsPage { formatSqliteUtcToLocalTime }
    "client/src/lib/table-sort" --> client.src.pages.AnalyticsPage {
        SortValueFn,
        sortRows,
        useTableSort,
    }
    client.src.lib.routing --> client.src.pages.AnalyticsPage { platformColors }
    "client/src/lib/chart-axis" --> client.src.pages.AnalyticsPage {
        categoryAxisProps,
        verticalCategoryAxisProps,
    }
    client.src.i18n.index --> client.src.pages.AnalyticsPage { useI18n }
    client.src.lib.search --> client.src.pages.AnalyticsPage { SearchAnalytics }
    client.src.components.ui.table --> "client/src/components/sortable-header" { TableHead }
    client.src.i18n.index --> "client/src/components/sortable-header" { useI18n }
    "client/src/lib/table-sort" --> "client/src/components/sortable-header" { SortState }
    "client/src/components/page-header" --> client.src.pages.LogsPage { PageHeader }
    "client/src/components/empty-state" --> client.src.pages.LogsPage { EmptyState }
    "client/src/components/confirm-button" --> client.src.pages.LogsPage { ConfirmButton }
    client.src.components.ui.badge --> client.src.pages.LogsPage { Badge }
    client.src.components.ui.button --> client.src.pages.LogsPage { Button }
    client.src.components.ui.input --> client.src.pages.LogsPage { Input }
    client.src.components.ui.select --> client.src.pages.LogsPage {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue,
    }
    client.src.components.ui.skeleton --> client.src.pages.LogsPage { Skeleton }
    client.src.lib.api --> client.src.pages.LogsPage { apiFetch }
    client.src.lib.toast --> client.src.pages.LogsPage { toast }
    client.src.lib.utils --> client.src.pages.LogsPage { cn }
    client.src.i18n.index --> client.src.pages.LogsPage { useI18n }
    client.src.lib.logs --> client.src.pages.LogsPage {
        DEFAULT_LOG_LEVELS,
        EMPTY_LOG_COUNTS,
        LOG_BUFFER_LIMIT,
        LOG_LEVELS,
        LOG_PAGE_LIMIT,
        LOG_POLL_MS,
        LogCounts,
        LogEntry,
        LogLevel,
        LogsResponse,
        advanceCursor,
        buildLogsQuery,
        clampMessage,
        collectEvents,
        collectProviders,
        formatLogTime,
        isLongMessage,
        levelsCsv,
        mergeEntries,
        toggleLevel,
    }
    client.src.lib.api --> client.src.pages.PremiumPage { apiFetch }
    "client/src/components/page-header" --> client.src.pages.PremiumPage { PageHeader }
    client.src.components.ui.button --> client.src.pages.PremiumPage { Button }
    client.src.components.ui.input --> client.src.pages.PremiumPage { Input }
    client.src.components.ui.label --> client.src.pages.PremiumPage { Label }
    client.src.components.ui.badge --> client.src.pages.PremiumPage { Badge }
    "client/src/components/ui/field-error" --> client.src.pages.PremiumPage { FieldError }
    client.src.components.ui.skeleton --> client.src.pages.PremiumPage { CardSkeleton }
    "client/src/hooks/use-premium" --> client.src.pages.PremiumPage { usePremium }
    client.src.i18n.index --> client.src.pages.PremiumPage { useI18n }
    client.src.components.ui.button --> client.src.pages.NotFoundPage { Button }
    client.src.i18n.index --> client.src.pages.NotFoundPage { useI18n }
    client.src.pages.useRecentAgents --> client.src.pages.AgentsPage { useRecentAgents }
    client.src.pages.DesktopAgentsPage --> client.src.pages.AgentsPage {
        DesktopAgentsPage,
        desktopAgentBridge,
    }
    client.src.lib.api --> client.src.pages.AgentsPage { apiFetch }
    client.src.i18n.index --> client.src.pages.AgentsPage { useI18n }
    "client/src/components/page-header" --> client.src.pages.AgentsPage { PageHeader }
    "client/src/components/copy-button" --> client.src.pages.AgentsPage { CopyButton }
    "client/src/components/agent-icons" --> client.src.pages.AgentsPage { AgentIcon }
    client.src.components.ui.button --> client.src.pages.AgentsPage { Button }
    client.src.components.ui.badge --> client.src.pages.AgentsPage { Badge }
    client.src.components.ui.card --> client.src.pages.AgentsPage {
        Card,
        CardAction,
        CardContent,
        CardDescription,
        CardHeader,
        CardTitle,
    }
    client.src.lib.api --> client.src.pages.useRecentAgents { apiFetch }
    "client/src/components/agent-icons" --> client.src.pages.DesktopAgentsPage { AgentIcon }
    "client/src/components/copy-button" --> client.src.pages.DesktopAgentsPage { CopyButton }
    client.src.i18n.index --> client.src.pages.DesktopAgentsPage { useI18n }
    client.src.lib.api --> client.src.pages.DesktopAgentsPage { apiFetch }
    "shared/agent-setup" --> client.src.pages.DesktopAgentsPage {
        AgentSetupBridge,
        SetupError,
        SetupFile,
        isTerminalAgent,
    }
    client.src.pages.useRecentAgents --> client.src.pages.DesktopAgentsPage { useRecentAgents }
    client.src.lib.utils --> "client/src/components/agent-icons" { cn }
    client.src.lib.utils --> client.src.components.ui.card { cn }
    client.src.App --> client.src.main { default }
    "server/src/lib/log-redaction" --> "server/src/__tests__/fixtures/stdio-epipe-child" {
        installLogRedaction,
    }
    "server/src/lib/process-safety-net" --> "server/src/__tests__/fixtures/stdio-epipe-child" {
        installProcessSafetyNet,
    }
    server.src.db.index --> "server/src/__tests__/fixtures/stdio-epipe-child" { initDb }
    server.src.db.types --> server.src.db.migrate.TEMPLATE { Db }
    server.src.env --> server.src.db.migrate.cli;
    server.src.db.types --> server.src.db.migrate.cli { Db }
    server.src.db.index --> server.src.db.migrate.cli { connectDb }
    server.src.db.migrate.runner --> server.src.db.migrate.cli {
        getMigrationStatuses,
        runMigrations,
    }
    server.src.env --> server.src.index;
    server.src.app --> server.src.index { createApp }
    server.src.db.index --> server.src.index { getDb, initDb }
    server.src.services.health --> server.src.index { checkAllKeys, startHealthChecker }
    server.src.lib.proxy --> server.src.index { flushProxyCache, restoreProxySettings }
    "server/src/lib/wake-detect" --> server.src.index { startWakeDetect }
    "server/src/services/catalog-sync" --> server.src.index { startCatalogSync }
    "server/src/services/cooldown-probe" --> server.src.index { startCooldownProbe }
    "server/src/services/model-probe" --> server.src.index { startModelProbe }
    "server/src/services/custom-model-sync" --> server.src.index { startCustomModelSync }
    "server/src/services/builtin-model-discovery" --> server.src.index {
        startBuiltinModelDiscovery,
    }
    "server/src/lib/process-safety-net" --> server.src.index { installProcessSafetyNet }
    server.src.lib.scheduler --> server.src.index { NodeScheduler }
    server.src.lib.config --> server.src.index { loadConfig }
    "server/src/services/declarative-config" --> server.src.index { applyDeclarativeConfigFromEnv }
    "server/src/lib/db-backup" --> server.src.index { restoreDbBackupIfNeeded, startDbBackupPump }
    server.src.services.backups --> server.src.index { startBackupScheduler }
    "server/src/lib/setup-code" --> server.src.index { generateSetupCode }
    "server/src/lib/env-drift" --> server.src.index { warnOnEnvDrift }
    "server/src/services/model-weight-overrides" --> server.src.index { warnOnRoutingOverrideDrift }
    "server/src/lib/log-redaction" --> server.src.index { installLogRedaction }
    server.src.services.ratelimit --> server.src.index { cleanupExpiredCooldowns }
    server.src.services.cache --> server.src.index { loadCacheFromDb }
    "server/src/lib/graceful-shutdown" --> server.src.index { installGracefulShutdown }
    server.src.db.index --> "server/src/scripts/export-catalog" { getDb, initDb }
    server.src.providers.index --> "server/src/scripts/export-catalog" { getAllProviders }
    server.src.services.quirks --> "server/src/scripts/export-catalog" {
        listQuirkDefinitions,
        quirkKey,
        resolveQuirksByModel,
    }
    server.src.db.index --> "server/src/scripts/routing-sim" { getDb, initDb }
    server.src.lib.crypto --> "server/src/scripts/routing-sim" { encrypt }
    server.src.services.router --> "server/src/scripts/routing-sim" {
        getRoutingScores,
        refreshStatsCache,
        routeRequest,
        setRoutingStrategy,
    }
    server.src.services.scoring --> "server/src/scripts/routing-sim" { RoutingStrategy }
    server.src.db.index --> "server/src/scripts/test-all-models" { getDb, initDb }
    server.src.lib.crypto --> "server/src/scripts/test-all-models" { decrypt }
    server.src.providers.index --> "server/src/scripts/test-all-models" { getProvider }
    server.src.services.scoring --> "server/src/__tests__/routes/anthropic.test" { RoutingStrategy }
    server.src.services.scoring --> "server/src/lib/client-context" { PresetStrategy }
    server.src.db.types --> "server/src/lib/endpoint-scope" { Db }
    "server/src/services/model-retirement" --> "server/src/lib/fallback-loop" {
        noteModelRetirementSignal,
    }
    server.src.services.auth --> server.src.routes.keys {
        SessionUser,
        clearReauthFailures,
        isSessionRecentlyReauthenticated,
        recordReauthFailure,
        verifyCredentials,
    }
    server.src.services.auth --> server.src.routes.ollama { validateSession }
    server.src.services.auth --> server.src.routes.auth {
        accountEmail,
        clearReauthFailures,
        createSession,
        createUser,
        deleteSession,
        desktopSessionToken,
        hashSessionToken,
        normalizeEmail,
        recordReauthFailure,
        resetUserPassword,
        sessionReauthenticatedUntilMs,
        updateEmail,
        updatePassword,
        userCount,
        validateSession,
        verifyCredentials,
    }
    server.src.services.auth --> server.src.services.oidc {
        createPasswordlessUser,
        createSession,
        normalizeEmail,
        stampSessionReauthenticated,
    }
    server.src.services.auth --> server.src.middleware.requireAuth { validateSession }
    server.src.services.auth --> server.src.__tests__.helpers.auth { createSession, createUser }
    server.src.services.auth --> "server/src/__tests__/routes/auth-desktop-session.test" {
        userCount,
        validateSession,
    }
    server.src.services.auth --> "server/src/__tests__/routes/auth-login-identifier.test" {
        createUser,
    }
    server.src.services.auth --> "server/src/__tests__/routes/auth-login-throttle.test" {
        createUser,
    }
    server.src.services.auth --> "server/src/__tests__/routes/auth-oidc.test" { createUser }
    server.src.services.auth --> "server/src/services/declarative-config" { createUser, userCount }
    "server/src/services/model-retirement" --> "server/src/__tests__/routes/custom-endpoint-identity.test" {
        noteModelRetirementSignal,
        resetModelRetirementObservations,
    }
    server.src.services.auth --> "server/src/__tests__/routes/keys-reveal.test" {
        createSession,
        resetReauthFailures,
        validateSession,
    }
    server.src.services.auth --> "server/src/__tests__/services/declarative-config.test" {
        userCount,
        verifyCredentials,
    }
    "server/src/services/model-retirement" --> "server/src/__tests__/services/model-retirement.test" {
        RETIREMENT_CONFIRMATIONS_REQUIRED,
        noteModelRetirementSignal,
        resetModelRetirementObservations,
    }
    server.src.services.auth --> server.src.index { userCount }
}
