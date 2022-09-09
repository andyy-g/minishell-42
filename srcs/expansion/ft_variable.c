/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_variable.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: charoua <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/07/13 15:48:08 by charoua           #+#    #+#             */
/*   Updated: 2022/09/08 23:14:55 by agranger         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minishell.h"

int	ft_isalnum(int c)
{
	return ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') \
			|| (c >= '0' && c <= '9'));
}

int	ft_ncmp(char *s1, char *s2, int n)
{
	int	i;

	i = 0;
	while (s1[i] != '\0' && s2[i] != '\0' && s1[i] == s2[i] && n > 0)
	{
		i++;
		n--;
	}
	if (n == 0 && s2[i] == '\0')
		return (1);
	return (0);
}

char	*ft_replacebyvar(char *str, char *var, int size, int pos)
{
	int		i;
	int		j;
	char	*new;

	i = 0;
	j = 0;
	new = (char *)malloc(sizeof(char) * size + 1);
	if (new)
	{
		while (str[i] != '$')
		{
			new[i] = str[i];
			i++;
		}
		while (var[j])
			new[i++] = var[j++];
		j = 0;
		while (str[pos + j])
			new[i++] = str[pos + j++];
		new[i] = '\0';
	}
	free(str);
	return (new);
}

int	ft_variable(t_pars **exp, t_env *env, int j)
{
	int		i;
	int		size;
	int		found;
	char	*str;
	char	*exit_status;

	i = j + 1;
	found = 0;
	str = (*exp)->str;
	while (str[i] && (ft_isalnum((int)str[i]) || str[i] == '_'))
		i++;
	while (i - 1 > j && env)
	{
		if (env->var && ft_ncmp(str + j + 1, env->var, i - j - 1))
		{
			size = ft_strlen(env->value) + ft_strlen(str) - i + j;
			(*exp)->str = ft_replacebyvar(str, env->value, size, i);
			found = 1;
			break ;
		}
		env = env->next;
	}
	if (i == j + 1 && str[i] && str[i] == '?')
	{
		exit_status = ft_itoa(g_exit_status);
		(*exp)->str = ft_replacebyvar(str, ft_itoa(g_exit_status), \
		ft_strlen(ft_itoa(g_exit_status)) + ft_strlen(str) - i - 1, i + 1);
		ft_free(exit_status);
	}
	else if (found == 0)
	{
		while (j < i && (*exp)->str[i])
			(*exp)->str[j++] = (*exp)->str[i++];
		(*exp)->str[j] = '\0';
	}
	if (!(*exp)->str)
		return (0);
	return (1);
}
