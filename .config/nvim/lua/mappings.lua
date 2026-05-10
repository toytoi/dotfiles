require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Markdown preview toggle
map("n", "<leader>mp", "<cmd>RenderMarkdown toggle<CR>", { desc = "Markdown: Toggle preview" })

map("n", "<leader>cc", ":VimtexCompile<CR>", { desc = "Vimtex: Compile" })
map("n", "<leader>cv", ":VimtexView<CR>", { desc = "Vimtex: View" })
map("n", "<leader>cq", ":VimtexStop<CR>", { desc = "Vimtex: Stop" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- LaTex
-- Generic Note
vim.api.nvim_create_user_command("NewLatexNote", function()
   local date = os.date "%Y-%m-%d" -- Today's date in YYYY-MM-DD format
   local filename = date .. ".tex"

   -- Open new file
   vim.cmd("edit " .. filename)

   -- Insert LaTeX template with NeurIPS-style margins and title
   local template = {
      "\\documentclass{article}",
      "\\usepackage[utf8]{inputenc}",
      "\\usepackage{amsmath, amssymb}", -- For math symbols and environments
      "\\usepackage{listings}", -- For code snippets
      "\\usepackage{graphicx}", -- For including images
      "\\usepackage[left=0.75in,right=0.75in,top=1in,bottom=1in]{geometry}", -- NeurIPS margins
      "\\usepackage{todonotes}", -- For todo notes
      "\\usepackage{fancyhdr}", -- For custom headers and footers
      "\\pagestyle{fancy}",
      "\\fancyhf{}",
      "\\rhead{" .. date .. "}", -- Right header: date
      "\\lhead{Notes for " .. date .. "}", -- Left header: "Notes for date"
      "",
      "\\title{\\textbf{Notes for " .. date .. "}}", -- Bold title per NeurIPS style
      "\\author{toytoi}", -- Your name
      "\\date{\\today}",
      "",
      "\\begin{document}",
      "\\maketitle",
      "",
      "\\section{Notes}",
      "Start writing your notes here...", -- Cursor will be placed here
      "",
      "% For math: \\[ equation \\]",
      "% For code: \\begin{lstlisting}[language=Python] code \\end{lstlisting}",
      "% For figure: \\begin{figure}[h] \\centering \\includegraphics{image} \\caption{caption} \\label{label} \\end{figure}",
      "% For table: \\begin{table}[h] \\centering \\begin{tabular}{columns} content \\end{tabular} \\caption{caption} \\label{label} \\end{table}",
      "% For todo: \\todo{note}",
      "% For references: \\begin{thebibliography}{9} \\bibitem{label} entry \\end{thebibliography}",
      "",
      "\\end{document}",
   }
   vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

   -- Find the line with "Start writing your notes here..." and place the cursor there
   local notes_line = 0
   for i, line in ipairs(template) do
      if line == "Start writing your notes here..." then
         notes_line = i
         break
      end
   end
   if notes_line > 0 then
      vim.api.nvim_win_set_cursor(0, { notes_line, 0 })
   end
end, { desc = "Create a new LaTeX note file" })

vim.api.nvim_create_user_command("NewMeetingNote", function()
   -- Generate filename with current date
   local date = os.date "%Y-%m-%d"
   local filename = "meeting_" .. date .. ".tex"
   vim.cmd("edit " .. filename)

   -- Define the LaTeX template with NeurIPS-style margins and title
   local template = {
      "\\documentclass{article}",
      "\\usepackage[utf8]{inputenc}",
      "\\usepackage{amsmath, amssymb}",
      "\\usepackage{enumitem}",
      "\\usepackage[left=0.75in,right=0.75in,top=1in,bottom=1in]{geometry}", -- NeurIPS margins
      "",
      -- Title formatting inspired by NeurIPS
      "\\title{\\textbf{Meeting Notes - Robotic Vision Lab}}",
      "\\author{Your Name}",
      "\\date{" .. date .. "}", -- Explicit date for meeting notes
      "",
      "\\begin{document}",
      "",
      "\\maketitle",
      "",
      "\\section*{Meeting Details}",
      "\\begin{itemize}",
      "\\item Date: " .. date,
      "\\item Time: [Time]",
      "\\item Location: [Location]",
      "\\item Attendees: [List of attendees]",
      "\\end{itemize}",
      "",
      "\\section*{Current Projects}",
      "[Notes on updates, progress, issues, and next steps for ongoing projects]",
      "",
      "\\section*{New Ideas}",
      "[Notes on any new concepts or approaches discussed]",
      "",
      "\\section*{Technical Challenges}",
      "[Notes on any problems or obstacles that need to be addressed]",
      "",
      "\\section*{Recent Papers}",
      "[Notes on recent papers or advancements in computer vision and event-based vision]",
      "",
      "\\section*{Action Items}",
      "\\begin{itemize}",
      "\\item Task 1",
      "\\item ...",
      "\\end{itemize}",
      "",
      "\\section*{Decisions}",
      "[Notes on any decisions made during the meeting]",
      "",
      "\\section*{Other Notes}",
      "[Any additional observations or notes]",
      "",
      "\\end{document}",
   }

   -- Insert the template into the buffer
   vim.api.nvim_buf_set_lines(0, 0, -1, false, template)

   -- Place cursor at the "[Time]" placeholder
   local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
   for i, line in ipairs(buf_lines) do
      if line:find "\\item Time: %[Time%]" then
         local col = line:find "%[Time%]" - 1 -- 0-based column for cursor
         vim.api.nvim_win_set_cursor(0, { i, col })
         break
      end
   end
end, { desc = "Create a new meeting note file" })

-- Optional keybinding
vim.keymap.set(
   "n",
   "<leader>mn",
   ":NewMeetingNote<CR>",
   { desc = "New Meeting Note" }
)

-- keybinding for NewLatexNote
map("n", "<leader>ln", ":NewLatexNote<CR>", { desc = "New LaTeX Note" })
