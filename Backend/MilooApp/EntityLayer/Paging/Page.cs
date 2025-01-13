using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EntityLayer.Paging
{
    public class Page
    {
        public const int DefaultPageNumber = 1;
        public const int DefaultPageSize = 16;
        public int _PageNumber { get; set; }
        public int _PageSize { get; set; }
        public int _TotalRowCount { get; set; }

        public int TotalPageCount
        {
            get
            {
                return (int)Math.Ceiling((double)_TotalRowCount / _PageSize);
            }
        }
        [JsonIgnore]
        public int Skip
        {
            get
            {
                return (_PageNumber - 1) * _PageSize;
            }
        }
        public bool HasNextPage
        {
            get
            {
                return _PageNumber < TotalPageCount;
            }
        }

        public bool HasPreviousPage
        {
            get
            {
                return _PageNumber > 1;
            }
        }

        public Page() : this(0)
        {

        }

        public Page(int pageNumber, int pageSize)
        {
            _PageNumber = pageNumber;
            _PageSize = pageSize;
        }
        public Page(int totolRowCount) : this(DefaultPageNumber, DefaultPageSize, totolRowCount)
        {
        }

        public Page(int currentPage, int PageSize, int TotalRowCount)
        {
            if (currentPage < 1)
            {
                throw new Exception("Invalid page number");
            }
            if (PageSize < 1)
            {
                throw new Exception("Invalid page size");
            }
            _PageNumber = currentPage;
            _PageSize = PageSize;
            _TotalRowCount = TotalRowCount;
        }
    }
}
