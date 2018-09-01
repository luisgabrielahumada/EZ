using Quantity.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Quantity.Services.Rules.Interface
{
    public partial interface IQuantity
    {
        IList<QuantityModel> DB_Quantity_List(int PageIndex, int PageSize, int? ProductId, out int TotalRecords);

        QuantityModel DB_Quantity_Get(Guid Token);

        void DB_Quantity_Delete(Guid Token);

        void DB_Quantity_Save(Guid Token, String Name, float Quantity, bool IsActive, int UpdatedId, string Products);

        void DB_Quantity_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);
    }
}