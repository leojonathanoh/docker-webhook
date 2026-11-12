$local:VERSIONS = @( Get-Content $PSScriptRoot/versions.json -Encoding utf8 -raw | ConvertFrom-Json )

# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    foreach ($v in $local:VERSIONS.webhook.versions) {
        @{
            package = 'webhook'
            package_version = $v
            distro = 'alpine'
            distro_version = '3.24'
            subvariants = @(
                @{ components = @() }
            )
        }
        @{
            package = 'webhook'
            package_version = $v
            distro = 'alpine'
            distro_version = '3.20'
            subvariants = @(
                @{ components = @( 'libvirt-10' ) }
            )
        }
        @{
            package = 'webhook'
            package_version = $v
            distro = 'alpine'
            distro_version = '3.19'
            subvariants = @(
                @{ components = @( 'libvirt-9' ) }
            )
        }
        @{
            package = 'webhook'
            package_version = $v
            distro = 'alpine'
            distro_version = '3.17'
            subvariants = @(
                @{ components = @( 'libvirt-8' ) }
                @{ components = @( 'curl', 'git', 'jq', 'sops', 'ssh' ) }
            )
        }
        @{
            package = 'webhook'
            package_version = $v
            distro = 'alpine'
            distro_version = '3.15'
            subvariants = @(
                @{ components = @( 'libvirt-7' ) }
            )
        }
        @{
            package = 'webhook'
            package_version = $v
            distro = 'alpine'
            distro_version = '3.13'
            subvariants = @(
                @{ components = @( 'libvirt-6' ) }
            )
        }
    }
)

$VARIANTS = @(
    foreach ($variant in $VARIANTS_MATRIX){
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    package_version = $variant['package_version']
                    distro = $variant['distro']
                    distro_version = $variant['distro_version']
                    platforms = & {
                        if ($variant -in @( '3.3', '3.4', '3.5' ) ) {
                            'linux/amd64'
                        }else {
                            'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64'
                        }
                    }
                    components = $subVariant['components']
                    job_group_key = $variant['package_version']
                }
                # Docker image tag. E.g. '2.8.1' or '2.8.1-libvirt-8'
                tag = @(
                        $variant['package_version']
                        $subVariant['components'] | ? { $_ }
                        # $variant['distro']
                        # $variant['distro_version']
                ) -join '-'
                tag_as_latest = if ($variant['package_version'] -eq $local:VARIANTS_MATRIX[0]['package_version'] -and $subVariant['components'].Count -eq 0) { $true } else { $false }
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'docker-entrypoint.sh' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}
