# Setup FRRouting (Free Range Routing)
class frr (
  String $repo_version = 'frr-stable',
) {
  contain frr::repo
  contain frr::install
}
