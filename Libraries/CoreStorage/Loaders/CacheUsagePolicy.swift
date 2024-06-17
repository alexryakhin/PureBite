public enum CacheUsagePolicy: String {
    /// Fetch. If failed, return error with previous content (if exists)
    case ignore
    /// Fetch. If failed, return error without content
    case ignoreAndResetPreviousContent
    /// Fetch. If failed and cache is up-to-date, return it. Return error otherwise
    case useIfFetchFails
    /// If cache is up-to-date, return it. Fetch otherwise. If fetching failed, return error
    case useIfUpToDate
//    /// If cache is up-to-date, return it. Fetch otherwise. If fetching failed, use outdated content
//    case useIfUpToDateOrOutdated
    /// If cache is up-to-date, return it. Fetch anyway. If fetching failed and cache is up-to-date, ignore error and continue to use cache. Return error otherwise
    case useAndThenFetch
    /// If cache is up-to-date, return it. Fetch anyway. If fetching failed, continue to use cache (even if cache is expired). If there is no cache, return error
    case useAndThenFetchIgnoringFails
}
