#!/bin/bash
real=$(blight get)
printf %.0f "$((10**3 * $real/255 * 100 ))e-3"
echo %
