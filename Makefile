# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tcarasso <tcarasso@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/01/11 14:47:55 by tcarasso          #+#    #+#              #
#    Updated: 2022/06/24 16:24:05 by agranger         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME			=	minishell

CFLAGS			=	-Wall -Wextra -Werror -g3 #-fsanitize=address

CC				=	gcc

SRCDIR			=	./srcs

OBJDIR			=	./objs

HEADERDIR		=	./headers

LIBFTDIR		=	./libft

LIBFT			=	$(LIBFTDIR)/libft.a

LIBRARY			=	-lreadline -lft -L$(LIBFTDIR)

CFILES			=	main.c \
					lexer/ft_lexer.c \
					lexer/ft_manage_struct.c \
					lexer/ft_token_bis.c \
					lexer/ft_token.c \
					error/ft_syntax_error.c \
					parser/node.c \
					parser/parser.c \
					parser/cmd.c \
					exit/exit.c \
					signals/eof.c \
					env/singleton_env.c
					
HFILES			=	$(HEADERDIR)/minishell.h

SRCS			=	$(addprefix $(SRCDIR)/,$(CFILES))

OBJS			=	$(addprefix $(OBJDIR)/,$(CFILES:.c=.o))

RM 				=	rm -rf


all				:	$(NAME)

$(NAME)			:	$(LIBFT) $(OBJDIR) $(OBJS) $(HFILES)
					@$(CC) $(CFLAGS) -I./$(HEADERDIR) $(OBJS) $(LIBRARY) -o $(NAME) 
					@echo "$(NAME) created"

$(LIBFT)		:
					@make -sC $(LIBFTDIR)

$(OBJDIR)		:
					@mkdir -p $(OBJDIR) \
						$(OBJDIR)/lexer \
						$(OBJDIR)/parser \
						$(OBJDIR)/exit \
						$(OBJDIR)/signals \
						$(OBJDIR)/env \
						$(OBJDIR)/error

$(OBJDIR)/%.o	:	$(SRCDIR)/%.c
					@$(CC) -o $@ -c $< $(CFLAGS) -I./$(HEADERDIR)

clean			: 
					@$(RM) $(OBJDIR)
					@make clean -sC $(LIBFTDIR)
					@echo "object files $(NAME) removed"

fclean			:	clean
					@make fclean -sC $(LIBFTDIR)
					@$(RM) $(NAME) 
					@echo "$(NAME) and libft.a removed"

re				:	fclean all

malloc_test		:	$(LIBFT) $(OBJDIR) $(OBJS) $(HFILES)
					$(CC) $(CFLAGS) -fsanitize=undefined -rdynamic -o $@ $(OBJS) $(LIBRARY) -ldl -L. -lmallocator

.PHONY			:	clean fclean re all
