#!/usr/bin/env bash

# Source patches: nullptr for GCC 14 type strictness, and a CommonJS-compatible bindings import.
sed -i \
    -e 's/reinterpret_cast<void\*>(NULL)/nullptr/g' \
    -e 's/import \* as getBindings from "bindings";/import getBindings = require("bindings");/g' \
    src/libxml2.cc lib/bindings/index.ts lib/sax.ts

# Guard against upstream drift silently no-op'ing the seds above.
if grep -rIlF 'reinterpret_cast<void*>(NULL)' src/libxml2.cc; then
    echo "libxmljs reinterpret_cast patch did not apply" >&2
    exit 1
fi
if grep -rIlF 'import * as getBindings from "bindings";' lib/bindings/index.ts lib/sax.ts; then
    echo "libxmljs bindings-import patch did not apply" >&2
    exit 1
fi
