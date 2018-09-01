using System.Collections.Generic;

namespace Types.Services.Rules.Interface
{
    public partial interface IType
    {
        IList<dynamic> DB_Type_List(int PageIndex, int PageSize, out int TotalRecords);
    }
}