using Ports.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Ports.Services.Rules.Interface
{
    public interface IPortsTask
    {
        void Save(Guid Token, String Name, String Address, String Phone, int City, float Ifo, float Mgo, String Terms, bool IsActive, int UpdatedId, float Draft, float Dwt);

        IList<PortsModel> Get(int PageIndex, int PageSize, out int TotalRecords, int? isActive);

        IList<DistanceBetweenPortsModel> GetDistanceBetweenPorts();

        void DistanceBetweenPorts(List<DistanceBetweenPortsModel> items, int UpdatedId);

        PortsModel Get(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);
    }
}