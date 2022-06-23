﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace KnowledgeMining.UI.Services.Search.Models
{
    public class SearchResponse
    {
        public IEnumerable<Document> Documents { get; set; } = Enumerable.Empty<Document>();
        public IEnumerable<AggregateFacet> Facets { get; set; } = Enumerable.Empty<AggregateFacet>();
        public int Page { get; set; }
        public IEnumerable<string> FacetableFields { get; set; } = Enumerable.Empty<string>();
        public long TotalCount { get; set; }
        public IEnumerable<AggregateFacet> Tags { get; set; } = Enumerable.Empty<AggregateFacet>();
        public string SearchId { get; set; }
    }
}