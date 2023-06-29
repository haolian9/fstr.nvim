provides a way to toggle between str and fstr for python buffer

## design choices
* only for python
* take advantage of treesitter rather than complicated string manipulations
* no automatic operation to toggle fstr

## status
* it just works
* it is feature-frozen

## prerequisites
* nvim 0.9.*
* treesitter
* haolian9/infra.nvim
* haolian9/squirrel.nvim

## usage
my personal config
```
bm.i("<c-f>", function() require("squirrel.fstr")() end)
```
