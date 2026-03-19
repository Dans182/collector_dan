class CardSearchFilters {
  const CardSearchFilters({
    this.textQuery,
    this.yearFrom,
    this.yearTo,
    this.teamId,
    this.rarityId,
    this.onlyRookieCards,
    this.onlyAutographed,
    this.onlyGraded,
    this.limit = 50,
    this.offset = 0,
  });

  final String? textQuery;
  final int? yearFrom;
  final int? yearTo;
  final String? teamId;
  final String? rarityId;
  final bool? onlyRookieCards;
  final bool? onlyAutographed;
  final bool? onlyGraded;
  final int limit;
  final int offset;
}
