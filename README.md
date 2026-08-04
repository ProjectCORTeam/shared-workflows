# shared-workflows

Workflows reutilizables (`workflow_call`) para el build/deploy de servicios de COR.

## Autenticación AWS (OIDC, sin access keys)

`aws-build.yml` y `aws-deploy.yml` autentican contra AWS con OIDC en vez de
`AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`. El caller necesita:

```yaml
permissions:
  id-token: write
  contents: read
```

Cada job asume `cor-role-infra-oidc` (cuenta `cor-infra`, 895242915726) directo vía OIDC,
y cuando necesita operar en otra cuenta, encadena (`role-chaining: true`) hacia el rol de
esa cuenta (`cor-role-staging-deploy`, `cor-role-prod-deploy`, `cor-role-shared-deploy`,
según el `stage`/uso). El segundo hop necesita `role-skip-session-tagging: true` — el
orquestador solo tiene permiso `sts:AssumeRole`, no `sts:TagSession`.

El repo que llama a estos workflows necesita estar en `allowed_repos` de
`cor-infrastructure/infra-terraform-backend/platform/terragrunt.hcl` — si no, falla con
`Not authorized to perform sts:AssumeRoleWithWebIdentity`. Ver ese repo para agregar uno nuevo,
bootstrapear una cuenta target, o entender la cadena completa de credenciales.

Nota: `beta` y `production` comparten cuenta y cluster (`cor-prod` / `cor-prod-us-east-2-all`)
en `aws-deploy.yml` — no son ambientes aislados a nivel de infraestructura, solo difieren en
namespace/release de Kubernetes.