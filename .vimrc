" Based on: https://www.freecodecamp.org/news/vimrc-configuration-guide-customize-your-vim-editor/
" Disable compatibility with vi which can cause unexpected issues.
set nocompatible
" Enable file type detection. Vim will be able to detect the type of file in
" use.
filetype on
" Enable plugins and load plugin for the detected file type.
filetype plugin on
" Load an indent file for the detexted file type.
filetype indent on
" Turn on syntax highlighting.
syntax on

" Add numbers to each line on the left-hand side.
set number
" Hilight cursor line underneath the cursor horizontally.
set cursorline
" Hilight cursor line underneath the cursor vertically.
set cursorcolumn

