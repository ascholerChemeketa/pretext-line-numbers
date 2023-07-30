<?xml version='1.0'?> <!-- As XML file -->

<!--********************************************************************
Copyright 2013 Robert A. Beezer

This file is part of MathBook XML.

MathBook XML is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 or version 3 of the
License (at your option).

MathBook XML is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MathBook XML.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************-->

<!-- http://pimpmyxslt.com/articles/entity-tricks-part2/ -->
<!DOCTYPE xsl:stylesheet [
    <!ENTITY % entities SYSTEM "entities.ent">
    %entities;
]>

<!-- Identify as a stylesheet -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:pi="http://pretextbook.org/2020/pretext/internal"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:exsl="http://exslt.org/common"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="pi exsl date str"
    xmlns:mb="https://pretextbook.org/"
    exclude-result-prefixes="mb"
>

<xsl:import href="./core/pretext-html.xsl"/>

<!-- syntax highlighting from Prism           -->
<xsl:template match="program" mode="code-inclusion">
    <xsl:variable name="prism-language">
        <xsl:apply-templates select="." mode="prism-language"/>
    </xsl:variable>
    <xsl:variable name="prism-line-highlight"><xsl:value-of select="@data-line" /></xsl:variable>
    <xsl:variable name="prism-line-numbers"><xsl:value-of select="@line-numbers" /></xsl:variable>
    <!-- a "program" element may be empty in a coding       -->
    <!-- exercise, and just used to indicate an interactive -->
    <!-- area supporting some language                      -->
    <xsl:variable name="b-has-input" select="not(normalize-space(input) = '')"/>
    <xsl:if test="$b-has-input">
        <!-- always identify as coming from "program" -->
        <pre>
            <xsl:if test="$prism-line-highlight != ''">
                <xsl:attribute name="data-line">
                    <xsl:value-of select="$prism-line-highlight"/>
                </xsl:attribute>
            </xsl:if>
                
            <!-- How to do this more cleanly??? -->
            <xsl:variable name="prism-class-name-base">program</xsl:variable>
            <xsl:variable name="prism-class-name-linenums">
                <xsl:if test="$prism-line-numbers != ''">line-numbers</xsl:if>
            </xsl:variable>
            <xsl:variable name="prism-class-name">
                <xsl:value-of select="normalize-space(concat($prism-class-name-base, ' ', $prism-class-name-linenums))"/>
            </xsl:variable>
            
            <xsl:attribute name="class" xml:space="default">
                <xsl:value-of select="$prism-class-name"/>
            </xsl:attribute>

            <code>
                <!-- Prism only needs a single class name, per language  -->
                <!-- placed on "code" but will migrate to the "pre" also -->
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="not($prism-language = '')">
                            <xsl:text>language-</xsl:text>
                            <xsl:value-of select="$prism-language" />
                        </xsl:when>
                        <!-- else, explicitly use what code gives -->
                        <xsl:otherwise>
                            <xsl:text>language-none</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:call-template name="sanitize-text">
                    <xsl:with-param name="text" select="input" />
                </xsl:call-template>
            </code>
        </pre>
    </xsl:if>
</xsl:template>

<!-- Program Listings highlighted by Prism - add extra js/css -->
<xsl:template name="syntax-highlight">
    <xsl:if test="$b-has-program and not($b-debug-react)">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.26.0/themes/prism.css" rel="stylesheet"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.26.0/components/prism-core.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.26.0/plugins/autoloader/prism-autoloader.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.26.0/plugins/line-numbers/prism-line-numbers.min.js" integrity="sha512-dubtf8xMHSQlExGRQ5R7toxHLgSDZ0K7AunqPWHXmJQ8XyVIG19S1T95gBxlAeGOK02P4Da2RTnQz0Za0H0ebQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.26.0/plugins/line-numbers/prism-line-numbers.min.css" integrity="sha512-cbQXwDFK7lj2Fqfkuxbo5iD1dSbLlJGXGpfTDqbggqjHJeyzx88I3rfwjS38WJag/ihH7lzuGlGHpDBymLirZQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.26.0/plugins/line-highlight/prism-line-highlight.min.css" integrity="sha512-nXlJLUeqPMp1Q3+Bd8Qds8tXeRVQscMscwysJm821C++9w6WtsFbJjPenZ8cQVMXyqSAismveQJc0C1splFDCA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.26.0/plugins/line-highlight/prism-line-highlight.min.js" integrity="sha512-93uCmm0q+qO5Lb1huDqr7tywS8A2TFA+1/WHvyiWaK6/pvsFl6USnILagntBx8JnVbQH5s3n0vQZY6xNthNfKA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    </xsl:if>
</xsl:template>


</xsl:stylesheet>
