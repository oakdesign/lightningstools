﻿using System;
using System.Collections.Generic;
using System.Linq;
using LibUsbDotNet;
using MadWizard.WinUSBNet;

namespace AnalogDevices
{
    internal class WinUsbDevice : IUsbDevice
    {
        private readonly USBDevice _winUsbDevice;

        public WinUsbDevice(USBDevice winUsbDevice)
        {
            _winUsbDevice = winUsbDevice;
        }

        public static IEnumerable<WinUsbDevice> AllDevices
        {
            get
            {
                return UsbDevice.AllWinUsbDevices.Where(x=>x.Device !=null).Select(x => new WinUsbDevice(USBDevice.GetSingleDevice(
                    x.SymbolicName.Substring(x.SymbolicName.IndexOf('{') + 1, 36))));
            }
        }

        public virtual void ControlTransfer(byte requestType, byte request, int value, int index, byte[] buffer = null,
            int? length = null)
        {
            _winUsbDevice.ControlTransfer(requestType, request, value, index, buffer ?? new byte[0],
                length ?? 0);
            ControlTransferSent?.Invoke(this,
                new ControlTransferSentEventArgs(requestType, request, value, index, buffer, length));
        }

        public event EventHandler<ControlTransferSentEventArgs> ControlTransferSent;
        public int Vid => _winUsbDevice.Descriptor.VID;
        public int Pid => _winUsbDevice.Descriptor.PID;
        public string SymbolicName => _winUsbDevice.Descriptor.PathName;

        public void Dispose()
        {
            _winUsbDevice.Dispose();
        }
    }
}