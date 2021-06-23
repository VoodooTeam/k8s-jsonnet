local AssetConfig(bucket_name, domain) = {
  bucket_name: 'gp-lig-' + bucket_name,
  url: 'https://' + domain + '/',
};

{
  withDomain(domain):: {
    badge: AssetConfig('badge-service-dev-public', 'badge-assets.' + domain),
    game: AssetConfig('game-service-dev-public', 'game-assets.' + domain),
    iap: AssetConfig('iap-service-dev-public', 'iap-assets.' + domain),
    league: AssetConfig('league-service-dev-public', 'league-assets.' + domain),
    user: AssetConfig('user-service-dev-public', 'user-assets.' + domain),
  },
}
