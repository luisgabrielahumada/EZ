using Types.Services.Rules.Interface;
using System.Collections.Generic;
using Insight.Database;
using Gesi.Access.Database;

namespace Types.Services.Rules.Task
{
    public class TypeServices : ITypeTask
    {
        public IList<dynamic> Get(int PageIndex, int PageSize, out int TotalRecords)
        {
            return Database.CurrentCnn.As<IType>().DB_Type_List(PageIndex, PageSize, out TotalRecords);
        }
    }
}