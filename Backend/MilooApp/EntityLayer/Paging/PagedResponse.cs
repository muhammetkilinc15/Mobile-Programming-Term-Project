using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityLayer.Paging
{
    public class PagedResponse<T> where T : class
    {
        public IList<T> Data { get; set; }
        public Page PageInfo { get; set; }

        public PagedResponse(IList<T> data, Page pageInfo)
        {
            Data = data;
            PageInfo = pageInfo;
        }

        public PagedResponse() : this((IList<T>)new List<T>(), new Page())
        {

        }
    }
}
