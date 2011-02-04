<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>

<template:include template="hidden.header"/>
<c:set var="linked" value="${uiComponents:getBindedComponent(currentNode, renderContext, 'j:bindedComponent')}"/>
<c:if test="${not empty linked}">
    <jcr:sql var="numberOfPostsQuery"
             sql="select [jcr:uuid] from [jnt:post] as p  where isdescendantnode(p,['${linked.path}'])"/>
    <c:set var="numberOfPosts" value="${numberOfPostsQuery.rows.size}"/>
    <jcr:sql var="numberOfThreadsQuery"
             sql="select [jcr:uuid] from [jnt:page] as t  where isdescendantnode(t,['${linked.path}'])"/>
    <c:set var="numberOfThreads" value="${numberOfThreadsQuery.rows.size}"/>
    <template:addResources type="css" resources="forum.css"/>
    <template:addCacheDependency node="${linked}"/>
    <div class="topics">
        <jcr:nodeProperty node="${linked}" name="jcr:title" var="topicSubject"/>
            <%--<c:if test="${!empty topicSubject.string}">--%>
            <%--<h2><a href="${url.base}${linked.parent.path}.forum-topic.html">${topicSubject.string}</a></h2>--%>
            <%--</c:if>--%>
        <div class="forum-box forum-box-style1 topics">
            <span class="forum-corners-top"><span></span></span>

            <ul class="forum-list">
                <li class="forum-list-header">
                    <dl class="icon">
                        <dt><fmt:message key="topic"/></dt>
                        <dd class="topics"><fmt:message key="posts"/></dd>
                            <%--<dd class="posts">View</dd>--%>
                        <dd class="lastpost"><span><fmt:message key="lastPosts"/></span></dd>
                    </dl>
                </li>
            </ul>


            <ul class="forum-list forums">
                <c:forEach items="${moduleMap.currentList}" var="subchild" varStatus="status" begin="${moduleMap.begin}" end="${moduleMap.end}">
                    <c:if test="${jcr:isNodeType(subchild, 'jnt:topic')}">
                        <li class="row">
                            <template:module node="${subchild}" template="${moduleMap.subNodesView}"/>
                        </li>
                        <c:set var="found" value="true"/>
                    </c:if>
                </c:forEach>

                <c:if test="${not found}">
                    <li class="row">
                        No topic found
                    </li>
                </c:if>

            </ul>
            <div class="clear"></div>
            <span class="forum-corners-bottom"><span></span></span>
        </div>
        <span><fmt:message key="total.threads"/>: ${numberOfThreads}</span>
        <span><fmt:message key="total.posts"/>: ${numberOfPosts}</span>
    </div>

</c:if>