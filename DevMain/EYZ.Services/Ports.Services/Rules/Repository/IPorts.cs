using Ports.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Ports.Services.Rules.Interface
{
    public partial interface IPorts
    {
        IList<PortsModel> DB_Port_List(int PageIndex, int PageSize, out int TotalRecords, int? isActive);

        IList<DistanceBetweenPortsModel> DB_DistanceBetweenPorts_List();

        PortsModel DB_Port_Get(Guid Token);

        void DB_Port_Delete(Guid Token);

        void DB_Port_Save(Guid Token, String Name, String Address, String Phone, int City, float Ifo, float Mgo, String Terms, bool IsActive, int UpdatedId);

        void DB_DistanceBetweenPorts_Save(string Items, int UpdatedId);

        void DB_Port_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);
    }
}