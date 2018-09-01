using System.Collections.Generic;

namespace Types.Services.Rules.Interface
{
    public interface ITypeTask
    {
        IList<dynamic> Get(int PageIndex, int PageSize, out int TotalRecords);
    }
}