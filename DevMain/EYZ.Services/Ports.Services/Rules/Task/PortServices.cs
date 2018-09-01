using Gesi.Access.Database;
using Insight.Database;
using Ports.Services.Rules.Interface;
using Ports.Services.Rules.Model;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Ports.Services.Rules.Task
{
    public class PortServices : IPortsTask
    {
        public IList<PortsModel> Get(int PageIndex, int PageSize, out int TotalRecords,int? isActive)
        {
            return Database.CurrentCnn.As<IPorts>().DB_Port_List(PageIndex, PageSize, out TotalRecords, isActive);
        }

        public PortsModel Get(Guid Token)
        {
            return Database.CurrentCnn.As<IPorts>().DB_Port_Get(Token);
        }

        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<IPorts>().DB_Port_Delete(Token);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IPorts>().DB_Port_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Save(Guid Token, String Name, String Address, String Phone, int City, float Ifo, float Mgo, String Terms, bool IsActive, int UpdatedId, float Draft, float Dwt)
        {
            Database.CurrentCnn.As<IPorts>().DB_Port_Save(Token, Name, Address, Phone, City, Ifo, Mgo, Terms, IsActive, UpdatedId, Draft, Dwt);
        }

        public IList<DistanceBetweenPortsModel> GetDistanceBetweenPorts()
        {
            return Database.CurrentCnn.As<IPorts>().DB_DistanceBetweenPorts_List();
        }

        public void DistanceBetweenPorts(List<DistanceBetweenPortsModel> items, int UpdatedId)
        {
            Database.CurrentCnn.As<IPorts>().DB_DistanceBetweenPorts_Save(string.Join("x", items.Select(k => $"{k.InputPortId}|{k.OutPutPortId}|{k.Interval}|{k.HourCanalPanama}|{k.IsActive}").ToArray()), UpdatedId);
        }
    }
}