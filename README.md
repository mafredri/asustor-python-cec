# python-cec-apkg

This package provides the [trainman419/python-cec](https://github.com/trainman419/python-cec) python module along with a python interpreter for ASUSTOR ADM.

## Instructions

After installation the `python2-cec` command can be used to invoke a python interpreter which includes the python-cec modules.

*sample_program.py*:

```
#!/usr/local/bin/python2-cec
import cec

cec.init()

device = cec.Device(0)

if device.is_on() is not True:
    device.power_on()
```

## Requirements

* Pulse-Eight [USB - CEC Adapter](http://www.pulse-eight.com/store/products/104-usb-hdmi-cec-adapter.aspx)
* [libcec-apkg](https://github.com/mafredri/libcec-apkg)

## Contains

* python-cec 0.2.2
* python 2.7.7