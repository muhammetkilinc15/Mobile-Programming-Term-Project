using EntityLayer.Paging;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Extensions
{
    public static class PagingExtension
    {
        public static async Task<PagedResponse<T>> GetPageAsync<T>(this IQueryable<T> query, int? currentPage, int? pageSize, CancellationToken cancellationToken = default) where T : class
        {
            var count = await query.CountAsync();

            Page paging = new(currentPage ?? 1, pageSize ?? 9, count);

            var data = await query
                .Skip(paging.Skip)
                .Take(paging._PageSize)
                .AsNoTracking()
                .ToListAsync(cancellationToken);
            var result = new PagedResponse<T>(data, paging);
            return result;
        }


    }
}
